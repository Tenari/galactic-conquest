<style>
  a {
    font-weight: bold;
    color: white;
    border: 1px solid white;
    padding: 5px;
  }
  a:hover {
    color: #00ff00;
    border-color: #00ff00;
  }
</style>
<script>
  let { data } = $props();
  console.log(data);
</script>
<h1>Solar Wars</h1>
<h4>A team-based, slow space combat strategy game.</h4>
<p>
  Two species vie for control of the galaxy, under the command of their Armada Admiral.
  The Admiral assigns objectives and resources to his Captains, who take the fight to the enemy as best they can.
  But space is vast and the fog of war is black, so thoughful Captains will triumph over their more reckless foes.
</p>
{#if !!data.user}
  <a href="/games">My games</a>
{:else}
  <p>
    Captain, please 
    <a href="/login">Login</a>
    to submit your orders.
  </p>
{/if}
