<script lang="ts">
  import { goto } from '$app/navigation';

  let usernameLogin = '';
  let passwordLogin = '';

  async function handleLogin() {
      console.log('Intentando iniciar sesión con:', usernameLogin, passwordLogin);
      // Aquí, en un escenario real, harías una llamada a tu API de autenticación
      goto('/dashboard');
  }

  function goToRegister() {
      goto('/register');
  }
</script>

<div class="hero is-fullheight">
  <div class="hero-body">
      <div class="container has-text-centered">
          <div class="columns is-centered">
              <div class="column is-4-desktop">
                  <h2 class="title is-3">Iniciar Sesión</h2>
                  <div class="box">
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
                              ¿No tienes una cuenta? <a href="#" on:click|preventDefault={goToRegister}>Crear cuenta</a>
                          </p>
                      </form>
                  </div>
              </div>
          </div>
      </div>
  </div>
</div>