<script>
  let newGame = $state({playerCount: "1", systemCount: "4"});
</script>

<h2>Game Setup</h2>

<div>
  <label>Players per Team</label>
  <select bind:value={newGame.playerCount}>
    <option value="1">Solo</option>
    <option value="2">Duo</option>
    <option value="3">Triumvirate</option>
    <option value="4">Squad (4)</option>
  </select>
</div>

<div>
  <label>Habitable Solar Systems in the Galaxy</label>
  <select bind:value={newGame.systemCount}>
    <option value="4">4</option>
    <option value="6">6</option>
    <option value="8">8</option>
    <option value="10">10</option>
  </select>
</div>
