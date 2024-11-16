<script>
  let { game } = $props();
  const startGame = () => {
    fetch(
      '/game?id='+game.id,
      {headers:{'Content-Type':'application/json'}, method: 'PUT'}
    ).then((data) => data.json()).then((data) => {
        console.log(data);
    })
  };
</script>
<h1>{game.name}</h1>
{#if game.status === 'waiting'}
<button onclick={startGame}>Start</button>
{/if}
