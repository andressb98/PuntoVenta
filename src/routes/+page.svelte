<script lang="ts">
    import { goto } from '$app/navigation';
    import { onMount } from 'svelte';
  
    let showLogin = true;
    let usernameLogin = '';
    let passwordLogin = '';
    let usernameRegister = '';
    let passwordRegister = '';
    let confirmPasswordRegister = '';
    let registrationError = '';
  
    async function handleLogin() {
      // Simulación de autenticación (sin base de datos aún)
      console.log('Intentando iniciar sesión con:', usernameLogin, passwordLogin);
      // Aquí, en un escenario real, harías una llamada a tu API de autenticación
  
      // Por ahora, simulamos un inicio de sesión exitoso
      goto('/admin/dashboard');
    }
  
    async function handleRegister() {
      if (passwordRegister !== confirmPasswordRegister) {
        registrationError = 'Las contraseñas no coinciden.';
        return;
      }
      // Simulación de creación de usuario (sin base de datos aún)
      console.log('Intentando registrar usuario con:', usernameRegister, passwordRegister);
      // Aquí, en un escenario real, harías una llamada a tu API para crear el usuario
  
      // Por ahora, simulamos un registro exitoso y mostramos el formulario de login
      showLogin = true;
      registrationError = '';
      // Opcionalmente, podrías mostrar un mensaje de éxito al usuario
    }
  
    function toggleForm() {
      showLogin = !showLogin;
      registrationError = ''; // Limpiar el error al cambiar de formulario
    }
  
    // Redirigir si ya hay una sesión activa (esto lo implementaremos con la autenticación real)
    onMount(() => {
      // Aquí iría la lógica para verificar si el usuario ya está autenticado
      // Si lo está, podrías hacer un goto('/admin/dashboard');
    });
  </script>
  
  <div class="hero is-fullheight">
    <div class="hero-body">
      <div class="container has-text-centered">
        <div class="columns is-centered">
          <div class="column is-4-desktop">
            <h2 class="title is-3">{showLogin ? 'Iniciar Sesión' : 'Crear Nueva Cuenta'}</h2>
            <div class="box">
              {#if showLogin}
                <form on:submit|preventDefault={handleLogin}>
                  <div class="field">
                    <label class="label">Usuario</label>
                    <div class="control">
                      <input class="input" type="text" placeholder="Tu nombre de usuario" bind:value={usernameLogin}>
                    </div>
                  </div>
  
                  <div class="field">
                    <label class="label">Contraseña</label>
                    <div class="control">
                      <input class="input" type="password" placeholder="Tu contraseña" bind:value={passwordLogin}>
                    </div>
                  </div>
  
                  <div class="field">
                    <div class="control">
                      <button type="submit" class="button is-primary is-fullwidth">Iniciar Sesión</button>
                    </div>
                  </div>
  
                  <p class="has-text-grey">
                    ¿No tienes una cuenta? <a href="#" on:click|preventDefault={toggleForm}>Crear cuenta</a>
                  </p>
                </form>
              {:else}
                <form on:submit|preventDefault={handleRegister}>
                  <div class="field">
                    <label class="label">Usuario</label>
                    <div class="control">
                      <input class="input" type="text" placeholder="Elige un nombre de usuario" bind:value={usernameRegister}>
                    </div>
                  </div>
  
                  <div class="field">
                    <label class="label">Contraseña</label>
                    <div class="control">
                      <input class="input" type="password" placeholder="Elige una contraseña" bind:value={passwordRegister}>
                    </div>
                  </div>
  
                  <div class="field">
                    <label class="label">Confirmar Contraseña</label>
                    <div class="control">
                      <input class="input" type="password" placeholder="Confirma tu contraseña" bind:value={confirmPasswordRegister}>
                    </div>
                  </div>
  
                  {#if registrationError}
                    <p class="help is-danger">{registrationError}</p>
                  {/if}
  
                  <div class="field">
                    <div class="control">
                      <button type="submit" class="button is-success is-fullwidth">Crear Cuenta</button>
                    </div>
                  </div>
  
                  <p class="has-text-grey">
                    ¿Ya tienes una cuenta? <a href="#" on:click|preventDefault={toggleForm}>Iniciar sesión</a>
                  </p>
                </form>
              {/if}
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>