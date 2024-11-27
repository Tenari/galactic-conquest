<script>
  import Game from './Game.svelte';
  import { context } from './state.svelte.js';
  const startGame = () => {
    fetch(
      '/game?id='+context.game.id,
      {headers:{'Content-Type':'application/json'}, method: 'PUT'}
    ).then((data) => data.json()).then((data) => {
      console.log(data);
      fetch(
        '/game?id='+context.game.id,
      ).then((data) => data.json()).then((data) => {
        context.game = data;
      })
    })
  };
  const joinGame = () => {
    fetch(
      '/game/join?id='+context.game.id,
      {headers:{'Content-Type':'application/json'}, method: 'POST'}
    ).then((data) => data.json()).then((data) => {
      console.log(data);
      if (data !== null) {
        context.game = data;
      }
    })
  };
</script>
<button onclick={() => (context.page = 'index')}>Back</button>
<h1>{context.game.name}</h1>
{#if context.user.name == context.game.creator && context.game.status === 'waiting'}
  <button onclick={startGame}>Start</button>
{/if}
{#if !context.game.players.includes(context.user.id) && context.game.status === 'waiting'}
  <button onclick={joinGame}>Join game</button>
{/if}
<ul>
  Players
{#each context.game.players as pl}
  <li>{pl}</li>
{/each}
</ul>
{#if context.game.status == 'playing'}
<Game/>
{/if}

