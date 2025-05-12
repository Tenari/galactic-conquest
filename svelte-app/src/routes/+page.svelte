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
  .typewriter-container {
      max-width: 600px;
      margin: 0 auto;
  }

  .line {
      overflow: hidden;
      white-space: nowrap;
      margin: 20px 0;
      border-right: 0.7em solid transparent;
      animation: blink 1s infinite;
      width: 0;
  }

  .line1 {
      border-color: #00e567;
      animation: typewriter1 3s steps(30) 1s forwards,
                 blink 1s 4;
  }

  .line2 {
      animation: typewriter2 3s steps(30) 4.5s forwards,
                 blink 1s 4 4.5s;
  }

  .line3 {
      animation: typewriter3 3s steps(26) 8s forwards,
                 blink 1s 4 8s;
  }

  .line4 {
      animation: typewriter4 3s steps(36) 11.5s forwards,
                 blink 1s 4 11.5s;
  }

  .line5 {
      animation: typewriter5 3s steps(31) 15s forwards,
                 blink 1s 4 15s;
  }

  .line6 {
      animation: typewriter6 3s steps(23) 18.5s forwards,
                 blink 1s 4 18.5s;
  }

  @keyframes typewriter1 {
      from { width: 0; }
      to { width: 30ch; }
  }

  @keyframes typewriter2 {
      from { width: 0; }
      to { width: 30ch; }
  }

  @keyframes typewriter3 {
      from { width: 0; }
      to { width: 26ch; }
  }
  @keyframes typewriter4 {
      from { width: 0; }
      to { width: 36ch; }
  }
  @keyframes typewriter5 {
      from { width: 0; }
      to { width: 31ch; }
  }
  @keyframes typewriter6 {
      from { width: 0; }
      to { width: 23ch; }
  }

  @keyframes blink {
      0%, 50% { border-color: #00e567; }
      51%, 100% { border-color: transparent; }
  }

  /* Remove cursor after typing is complete */
  .line1 { animation-delay: 1s; animation-fill-mode: forwards; }
  .line2 { animation-delay: 4.5s; animation-fill-mode: forwards; }
  .line3 { animation-delay: 8s; animation-fill-mode: forwards; }

</style>
<script>
  let { data } = $props();
  console.log(data);
</script>
<h1>Solar Wars</h1>
<h4>A team-based, slow space combat strategy game.</h4>
<p>[GALACTIC COMMAND PROTOCOL INITIATED]</p>
<p class="line line1">> ACCESSING FLEET DATABASE...</p>
<p class="line line2">> Team-based strategic combat</p>
<p class="line line3">> Slow-burn space warfare</p>
<p class="line line4">> Admiral-Captain command structure</p>
<p class="line line5">> Fog of war simulation active</p>
<p class="line line6">> READY FOR DEPLOYMENT</p>
<p>
  Two species vie for control of the galaxy, under the command of their Armada Admiral.
  The Admiral assigns objectives and resources to his Captains, who take the fight to the enemy as best they can.
  But space is vast and the fog of war is black, so thoughful Captains will triumph over their more reckless foes.
</p>
{#if !!data.user}
  <a href="/games">My games</a>
{:else}
  <p class="mt-3">
    Captain, please 
    <a href="/login">Login</a>
    to submit your orders.
  </p>
{/if}

<footer>SOLAR WARS © 2025 | ALL SYSTEMS OPERATIONAL | ADMIRALTY CODE: SW-7831-DELTA</footer>
