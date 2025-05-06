<script>
  let { data } = $props();
</script>
<h1>Solar Wars</h1>
<h4>A team-based, slow space combat strategy game.</h4>
<p>
  Two species vie for control of the galaxy, under the command of their Armada Admiral.
  The Admiral assigns objectives and resources to his Captains, who take the fight to the enemy as best they can.
  But space is vast and the fog of war is black, so thoughful Captains will triumph over their more reckless foes.
  We await your orders, sir.
</p>
{#if !!data.user}
  <a href="/games">My games</a>
{:else}
  <a href="/login">Login</a>
{/if}
