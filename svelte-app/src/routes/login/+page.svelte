<style>
.showcursor::after {
  content: " ";
  display: inline-block;
  height: 1.1em;
  margin-top: -4px;
  width: 0.5em;
  vertical-align: middle;
  -webkit-animation: 1s blink step-end infinite;
  -moz-animation: 1s blink step-end infinite;
  -ms-animation: 1s blink step-end infinite;
  -o-animation: 1s blink step-end infinite;
  animation: 1s blink step-end infinite;
}

@keyframes blink {
  from,
  to {
    background: 0 0;
  }
  50% {
    background: #00E567;
  }
}

@-moz-keyframes blink {
  from,
  to {
    background: 0 0;
  }
  50% {
    background: #00E567;
  }
}

@-webkit-keyframes blink {
  from,
  to {
    background: 0 0;
  }
  50% {
    background: #00E567;
  }
}

@-ms-keyframes blink {
  from,
  to {
    background: 0 0;
  }
  50% {
    background: #00E567;
  }
}

@-o-keyframes blink {
  from,
  to {
    background: 0 0;
  }
  50% {
    background: #00E567;
  }
}
</style>

<script>
  import TerminalInput from '$lib/TerminalInput.svelte';

  const buttonStyle = "border border-white p-1 hover:font-bold hover:text-black hover:bg-emerald-100 cursor-pointer mb-2";
  const inputStyle = "border-2 border-white p-2 outline-none focus:border-lime-500";
  let {data, form} = $props();
  let email = $state("");
  let emailIsValid = $derived(email.includes("@") && email.includes("."));
  let invalidEmailError = $state("");
  let showingCodeForm = $state(false);
  let showingCodeOptions = $derived(emailIsValid && !showingCodeForm);
  function ihaveacode(e) {
    e.preventDefault();
    showingCodeForm = true;
  }
  console.log(data, form);

</script>

<p>> login</p>

<form method="POST" action="?/checkCode">
  <p>
    What is your email? >
    <input name="email" type="email" bind:value={email} class={inputStyle}/>
  </p>

  {#if form?.error}
    <p class="text-red-500">{form?.error}</p>
  {/if}
  {#if showingCodeOptions}
  <div>
    <span>Select one:</span>
    <ol class="list-decimal ml-8">
      <li>
        <button class={buttonStyle} formaction="?/makeCode">
          SEND ME A CODE
        </button>
      </li>
      <li>
        <button class={buttonStyle} onclick={ihaveacode}>I HAVE A CODE</button>
      </li>
    </ol>
  </div>
  {/if}

  {#if showingCodeForm}
    <div class="mt-3">
      <label>
        Login Code
        <input name="code" type="text" class={inputStyle} />
      </label>
      <button>[ENTER]</button>
    </div>
  {/if}
</form>

<!--
  <input name="email" type="email" class="text-white blink-cursor bg-red" bind:value={email}>

<form method="POST" action="?/makeCode">
	<label>
		Email
    <input name="email" type="email" class="text-white blink-cursor bg-red" autofocus value={form?.email} {#if !!(form?.email)}disabled{/if}>
	</label>
	<button>[ENTER]</button>
</form>

{#if form?.needCode}
<form method="POST" action="?/checkCode">
	<label>
		Login Code
    <input name="code" type="text" class="text-white blink-cursor bg-red" autofocus >
	</label>
	<button>[ENTER]</button>
</form>
{/if}
-->
