<script>
  import { context } from './state.svelte.js';
  import GameLobby from './GameLobby.svelte';
  let loginName = $state("");
  let loginPass = $state("");
  let creatingGame = $state(false);
  let newGame = $state({name: "", mode: "single_free_for_all"});
  const goto = (routename) => {
    context.page = routename;
  };
  fetch('/user').then((data)=> data.json()).then((data) => {
    if (data.name) {
      context.user = data;
    }
  });
  const loginOrSignUp = () => {
    fetch(
      '/user',
      {
        headers: {'Content-Type':'application/json'},
        method: 'POST',
        body: JSON.stringify({name: loginName, pw: loginPass})
      }
    ).then((data) => data.json()).then((data) => {
        context.user = data;
    })
  };
  const createGame = () => {
    fetch(
      '/game',
      {
        headers: {'Content-Type':'application/json'},
        method: 'POST',
        body: JSON.stringify(newGame)
      }
    ).then((data) => data.json())
      .then((data) => {
        if (data.result === 'added') {
          fetch('/game?list=true')
            .then((data)=> data.json())
            .then((gms) => {
            context.games = gms;
          })
        }
      })
  };
  $effect(() => {
    if (context.user !== null) {
      fetch('/game?list=true')
        .then((data)=> data.json())
        .then((gms) => {
        context.games = gms;
      })
    }
  });
</script>

<style>
  .game-listing {
    display: flex;
    border-color: rgb(248 250 252);
    border-width: 1px;
    border-radius: 0.25rem;
    padding: 1rem;
    background-color: rgb(15 23 42);
  }
  .game-listing .name {
    font-weight: bold;
  }
  .details {
    font-size: 1.125rem; /* 18px */
    line-height: 1.75rem; /* 28px */
    color: rgb(248 250 252);
  }
</style>

<div class="page">
  {#if context.page === 'index'}
  <h1>Galactic Conquest</h1>
  {#if context.user === null}
    <h2>Log In/Sign up</h2>
    <div>Name: <input type="text" bind:value={loginName}/></div>
    <div>Password: <input type="password" bind:value={loginPass} /></div>
    <button onclick={loginOrSignUp}>Submit</button>
  {:else}
    <p>Welcome back, {context.user.name}</p>
    <button onclick={() => (creatingGame = !creatingGame)}>{creatingGame ? 'Cancel' : 'New Game'}</button>
    {#if creatingGame}
      <div>
        <h3>Your new game</h3>
        <div>Name: <input type="text" bind:value={newGame.name}/></div>
        <div>
          Mode:
          <select bind:value={newGame.mode}>
            <option value="single_teams">Teams</option>
            <option value="single_free_for_all">Free for all</option>
          </select>
        </div>
        <button onclick={createGame}>Submit</button>
      </div>
    {/if}
    <h2>Join a Game</h2>
    <ul>
      {#each context.games as game}
        <li class="game-listing" onclick={()=> {context.game = game; goto('game_lobby')}}>
          <div class="details">
            <div class="name">{game.name}</div>
            <div class="status">{game.status}</div>
          </div>
          <div>{game.players.filter(id => id !== 0).length} / {game.max_players} players</div>
          <button>Join</button>
        </li>
      {/each}
    </ul>
    {/if}
  {/if}
  {#if context.page === 'game_lobby'}
    <GameLobby />
  {/if}
</div>
