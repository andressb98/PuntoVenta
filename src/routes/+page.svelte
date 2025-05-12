<script lang="ts">
    import { goto } from '$app/navigation';
  
    let usernameLogin = '';
    let passwordLogin = '';
    let errorMessage = '';
  
    async function handleLogin() {
      try {
        const response = await fetch('/api/login', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            username: usernameLogin,  // Cambiado de email a username
            password: passwordLogin
          }),
        });
  
        const data = await response.json();
  
        if (response.ok) {
          // Guardar el token de autenticación si es necesario
          if (data.token) {
            localStorage.setItem('authToken', data.token);
            // También puedes guardar información del usuario si lo necesitas
            localStorage.setItem('user', JSON.stringify(data.user));
          }
          goto('/dashboard');
        } else {
          errorMessage = data.message || 'Error al iniciar sesión';
        }
      } catch (error) {
        errorMessage = 'Error de conexión con el servidor';
        console.error('Error:', error);
      }
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
            {#if errorMessage}
              <div class="notification is-danger">
                {errorMessage}
              </div>
            {/if}
            <div class="box">
              <form on:submit|preventDefault={handleLogin}>
                <div class="field">
                  <label class="label">Nombre de Usuario</label>  <!-- Cambiado de Email -->
                  <div class="control">
                    <input class="input" type="text" placeholder="Tu nombre de usuario" bind:value={usernameLogin} required>
                  </div>
                </div>
  
                <div class="field">
                  <label class="label">Contraseña</label>
                  <div class="control">
                    <input class="input" type="password" placeholder="Tu contraseña" bind:value={passwordLogin} required>
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