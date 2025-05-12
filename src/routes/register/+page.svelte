<script lang="ts">
	import { onMount } from 'svelte';
	import { goto } from '$app/navigation';

	let username = '';
	let password = '';
	let confirmPassword = '';
	let idRol: number | null = null;
	let roles: { id: number; nombre: string }[] = [];
	let registrationError = '';

	onMount(async () => {
		try {
			const res = await fetch('/api/roles');
			const data = await res.json();
			if (res.ok) {
				roles = data.roles;
			} else {
				console.error('Error al obtener roles');
			}
		} catch (e) {
			console.error('Fallo en la carga de roles:', e);
		}
	});

	async function handleRegister() {
		if (password !== confirmPassword) {
			registrationError = 'Las contraseñas no coinciden.';
			return;
		}

		if (!username || !password || idRol === null) {
			registrationError = 'Todos los campos obligatorios deben completarse.';
			return;
		}

		try {
			const response = await fetch('/api/register', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({
					username,
					password,
					id_rol: idRol
				})
			});

			const data = await response.json();

			if (!response.ok) {
				registrationError = data.error || 'Error al registrar el usuario.';
				return;
			}

			goto('/dashboard');
		} catch (error) {
			console.error('Error en el registro:', error);
			registrationError = 'Error de conexión. Por favor intenta nuevamente.';
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
										bind:value={username}
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
										bind:value={password}
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
										bind:value={confirmPassword}
									/>
								</div>
							</div>

							<div class="field">
								<label class="label">Rol*</label>
								<div class="control">
									<div class="select is-fullwidth">
										<select bind:value={idRol} required>
											<option value="" disabled selected>Selecciona un rol</option>
											{#each roles as rol}
												<option value={rol.id}>{rol.nombre}</option>
											{/each}
										</select>
									</div>
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
