<script lang="ts">
	import { goto } from '$app/navigation';

	let usernameRegister = '';
	let passwordRegister = '';
	let confirmPasswordRegister = '';
	let registrationError = '';

	async function handleRegister() {
		if (passwordRegister !== confirmPasswordRegister) {
			registrationError = 'Las contraseñas no coinciden.';
			return;
		}

		try {
			const response = await fetch('/api/register', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({
					email: usernameRegister,
					password: passwordRegister,
					nombre: usernameRegister
				})
			});

			const data = await response.json();

			if (!response.ok) {
				// Muestra el error específico del backend
				registrationError = data.error || 'Error al registrar el usuario.';
				if (data.details) console.error('Detalles del error:', data.details);
				return;
			}

			// Redirigir al login después del registro exitoso
			goto('/login');
		} catch (error) {
			console.error('Error en el registro:', error);
			registrationError = `Error de conexión: ${error.message}`;
		}
	}

	function goToLogin() {
		goto('/login');
	}
</script>

<div class="hero is-fullheight">
	<div class="hero-body">
		<div class="container has-text-centered">
			<div class="columns is-centered">
				<div class="column is-4-desktop">
					<h2 class="title is-3">Crear Nueva Cuenta</h2>
					<div class="box">
						<form on:submit|preventDefault={handleRegister}>
							<div class="field">
								<label class="label">Usuario</label>
								<div class="control">
									<input
										class="input"
										type="text"
										placeholder="Elige un nombre de usuario"
										bind:value={usernameRegister}
									/>
								</div>
							</div>

							<div class="field">
								<label class="label">Contraseña</label>
								<div class="control">
									<input
										class="input"
										type="password"
										placeholder="Elige una contraseña"
										bind:value={passwordRegister}
									/>
								</div>
							</div>

							<div class="field">
								<label class="label">Confirmar Contraseña</label>
								<div class="control">
									<input
										class="input"
										type="password"
										placeholder="Confirma tu contraseña"
										bind:value={confirmPasswordRegister}
									/>
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
								¿Ya tienes una cuenta? <a href="#" on:click|preventDefault={goToLogin}
									>Iniciar sesión</a
								>
							</p>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
