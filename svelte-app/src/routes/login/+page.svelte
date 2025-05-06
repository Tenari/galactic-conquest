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
  let {data, form} = $props();
  let email = $state("");
  let emailIsValid = $derived(email.includes("@") && email.includes("."));
  let showingEmailOptions = $state(false);
  let focused = $state(false);
  let showcursor = $derived(!showingEmailOptions && focused);
  let invalidEmailError = $state("");
  let showingCodeForm = $state(false);

  function onblur(event) {
    focused = false;
  }

  function onfocus(event) {
    focused = true;
  }

  function onkeypress(event) {
    if (event.key === "Enter") {
      event.preventDefault();
      event.stopPropagation();
      if (emailIsValid) {
        showingEmailOptions = true;
        invalidEmailError = "";
      } else {
        invalidEmailError = "invalid email";
      }
    }
	}

  function ihaveacode() {
    showingCodeForm = true;
  }
</script>


<p>> login</p>

<p>
  What is your email? >
  <span {onkeypress} {onblur} {onfocus} autofocus contenteditable="true" bind:textContent={email} class={[{showcursor}, "outline-none cursor-text caret-transparent min-w-sm"]}></span>
</p>

{#if invalidEmailError}
  <p class="text-red-500">Invalid email</p>
{/if}
{#if showingEmailOptions}
<div>
  <span>Select one:</span>
  <ol class="list-decimal ml-8">
    <li><button class="border border-white p-1 hover:font-bold hover:text-black hover:bg-emerald-100 cursor-pointer mb-2">SEND ME A CODE</button></li>
    <li>
      <button class="border border-white p-1 hover:font-bold hover:text-black hover:bg-emerald-100 cursor-pointer" onclick={ihaveacode}>I HAVE A CODE</button>
    </li>
  </ol>
</div>
{/if}

{#if showingCodeForm}
<form method="POST" action="?/checkCode">
	<label>
		Login Code
    <input name="code" type="text" class="text-white blink-cursor bg-red" autofocus >
	</label>
	<button>[ENTER]</button>
</form>
{/if}

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
