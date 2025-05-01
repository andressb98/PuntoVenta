<script lang="ts">
    // Tipos
    type Cliente = {
      id: number;
      nombre: string;
      rfc: string;
      direccion: string;
      telefono: string;
      email: string;
      credito: {
        disponible: number;
        limite: number;
        diasCredito: number;
      };
      ultimaCompra: string;
      activo: boolean;
    };
  
    // Estado
    let clientes: Cliente[] = [
      {
        id: 1,
        nombre: "Empresa ABC SA de CV",
        rfc: "ABC1234567890",
        direccion: "Av. Comercial 123, Ciudad de México",
        telefono: "5551234567",
        email: "contacto@empresaabc.com",
        credito: {
          disponible: 15000,
          limite: 20000,
          diasCredito: 30
        },
        ultimaCompra: "2023-05-15",
        activo: true
      },
      {
        id: 2,
        nombre: "Distribuidora XYZ",
        rfc: "XYZ9876543210",
        direccion: "Calle Distribución 456, Guadalajara",
        telefono: "3339876543",
        email: "ventas@distribuidoraxyz.com",
        credito: {
          disponible: 5000,
          limite: 10000,
          diasCredito: 15
        },
        ultimaCompra: "2023-05-10",
        activo: true
      },
      {
        id: 3,
        nombre: "Tienda Minorista 123",
        rfc: "TMI4567890123",
        direccion: "Boulevard Ventas 789, Monterrey",
        telefono: "8187654321",
        email: "info@tiendaminorista123.com",
        credito: {
          disponible: 0,
          limite: 0,
          diasCredito: 0
        },
        ultimaCompra: "2023-04-20",
        activo: false
      }
    ];
  
    let busqueda: string = "";
    let modalAgregarCliente = false;
    let modalCredito = false;
    let clienteSeleccionado: Cliente | null = null;
    let nuevoCliente: Omit<Cliente, "id" | "credito" | "ultimaCompra"> & {
      credito: {
        limite: number;
        diasCredito: number;
      };
    } = {
      nombre: "",
      rfc: "",
      direccion: "",
      telefono: "",
      email: "",
      credito: {
        limite: 0,
        diasCredito: 0
      },
      activo: true
    };
  
    // Funciones
    function agregarCliente() {
      if (nuevoCliente.nombre && nuevoCliente.rfc) {
        const nuevoId = Math.max(...clientes.map(c => c.id), 0) + 1;
        clientes = [...clientes, {
          id: nuevoId,
          ...nuevoCliente,
          credito: {
            disponible: nuevoCliente.credito.limite,
            limite: nuevoCliente.credito.limite,
            diasCredito: nuevoCliente.credito.diasCredito
          },
          ultimaCompra: "Nunca"
        }];
        resetearFormulario();
        modalAgregarCliente = false;
      }
    }
  
    function prepararAsignarCredito(cliente: Cliente) {
      clienteSeleccionado = JSON.parse(JSON.stringify(cliente));
      modalCredito = true;
    }
  
    function toggleEstadoCliente(id: number) {
      clientes = clientes.map(c => 
        c.id === id ? { ...c, activo: !c.activo } : c
      );
    }
  
    function resetearFormulario() {
      nuevoCliente = {
        nombre: "",
        rfc: "",
        direccion: "",
        telefono: "",
        email: "",
        credito: {
          limite: 0,
          diasCredito: 0
        },
        activo: true
      };
    }
  
    // Filtrado
    $: clientesFiltrados = clientes.filter(c =>
      c.nombre.toLowerCase().includes(busqueda.toLowerCase()) ||
      c.rfc.toLowerCase().includes(busqueda.toLowerCase())
    );
  </script>
  
  <div class="container py-4">
    <h1 class="title is-2">Gestión de Clientes</h1>
  
    <!-- Barra de búsqueda y acciones -->
    <div class="level">
      <div class="level-left">
        <div class="level-item">
          <div class="field has-addons">
            <div class="control">
              <input
                class="input"
                type="text"
                placeholder="Buscar clientes..."
                bind:value={busqueda}
              />
            </div>
            <div class="control">
              <button class="button is-info">
                <span class="icon">
                  <i class="fas fa-search"></i>
                </span>
              </button>
            </div>
          </div>
        </div>
      </div>
      <div class="level-right">
        <div class="level-item">
          <button class="button is-primary" onclick={() => modalAgregarCliente = true}>
            <span class="icon">
              <i class="fas fa-plus"></i>
            </span>
            <span>Nuevo Cliente</span>
          </button>
        </div>
      </div>
    </div>
  
    <!-- Tabla de clientes -->
    <div class="box">
      <div class="table-container">
        <table class="table is-fullwidth is-hoverable is-striped">
          <thead>
            <tr>
              <th>Nombre/RFC</th>
              <th>Contacto</th>
              <th>Crédito</th>
              <th>Última Compra</th>
              <th>Estado</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            {#each clientesFiltrados as cliente (cliente.id)}
              <tr>
                <td>
                  <p class="has-text-weight-bold">{cliente.nombre}</p>
                  <p class="is-size-7 has-text-grey">{cliente.rfc}</p>
                </td>
                <td>
                  <p>{cliente.telefono}</p>
                  <p class="is-size-7 has-text-grey">{cliente.email}</p>
                  <p class="is-size-7 has-text-grey">{cliente.direccion}</p>
                </td>
                <td>
                  {#if cliente.credito.limite > 0}
                    <p>Disponible: ${cliente.credito.disponible.toFixed(2)}</p>
                    <p class="is-size-7">Límite: ${cliente.credito.limite.toFixed(2)}</p>
                    <p class="is-size-7">Días: {cliente.credito.diasCredito}</p>
                  {:else}
                    <p class="has-text-grey">Sin crédito</p>
                  {/if}
                </td>
                <td>{cliente.ultimaCompra}</td>
                <td>
                  <span class="tag {cliente.activo ? 'is-success' : 'is-danger'}">
                    {cliente.activo ? 'Activo' : 'Inactivo'}
                  </span>
                </td>
                <td>
                  <div class="buttons are-small">
                    <button class="button is-info is-light" onclick={() => {}}>
                      <span class="icon">
                        <i class="fas fa-history"></i>
                      </span>
                      <span>Historial</span>
                    </button>
                    <button 
                      class="button is-warning is-light" 
                      onclick={() => prepararAsignarCredito(cliente)}
                      disabled={!cliente.activo}
                    >
                      <span class="icon">
                        <i class="fas fa-credit-card"></i>
                      </span>
                      <span>Crédito</span>
                    </button>
                    <button 
                      class="button {cliente.activo ? 'is-warning' : 'is-success'} is-light" 
                      onclick={() => toggleEstadoCliente(cliente.id)}
                    >
                      <span class="icon">
                        <i class="fas {cliente.activo ? 'fa-toggle-off' : 'fa-toggle-on'}"></i>
                      </span>
                      <span>{cliente.activo ? 'Desactivar' : 'Activar'}</span>
                    </button>
                  </div>
                </td>
              </tr>
            {/each}
          </tbody>
        </table>
      </div>
    </div>
  
    <!-- Modal para agregar cliente -->
    <div class="modal" class:is-active={modalAgregarCliente}>
      <div class="modal-background" onclick={() => modalAgregarCliente = false}></div>
      <div class="modal-card">
        <header class="modal-card-head">
          <p class="modal-card-title">Agregar Nuevo Cliente</p>
          <button class="delete" aria-label="close" onclick={() => modalAgregarCliente = false}></button>
        </header>
        <section class="modal-card-body">
          <div class="field">
            <label class="label">Nombre/Razón Social*</label>
            <div class="control">
              <input class="input" type="text" placeholder="Nombre completo" bind:value={nuevoCliente.nombre} required>
            </div>
          </div>
          
          <div class="field">
            <label class="label">RFC*</label>
            <div class="control">
              <input class="input" type="text" placeholder="RFC" bind:value={nuevoCliente.rfc} required>
            </div>
          </div>
          
          <div class="field">
            <label class="label">Dirección</label>
            <div class="control">
              <input class="input" type="text" placeholder="Dirección completa" bind:value={nuevoCliente.direccion}>
            </div>
          </div>
          
          <div class="columns">
            <div class="column">
              <div class="field">
                <label class="label">Teléfono*</label>
                <div class="control">
                  <input class="input" type="tel" placeholder="Teléfono" bind:value={nuevoCliente.telefono} required>
                </div>
              </div>
            </div>
            <div class="column">
              <div class="field">
                <label class="label">Correo Electrónico</label>
                <div class="control">
                  <input class="input" type="email" placeholder="email@cliente.com" bind:value={nuevoCliente.email}>
                </div>
              </div>
            </div>
          </div>
          
          <div class="field">
            <label class="label">Línea de Crédito</label>
            <div class="columns">
              <div class="column">
                <div class="field">
                  <label class="label">Límite ($)</label>
                  <div class="control">
                    <input class="input" type="number" min="0" bind:value={nuevoCliente.credito.limite}>
                  </div>
                </div>
              </div>
              <div class="column">
                <div class="field">
                  <label class="label">Días de Crédito</label>
                  <div class="control">
                    <input class="input" type="number" min="0" bind:value={nuevoCliente.credito.diasCredito}>
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <div class="field">
            <div class="control">
              <label class="checkbox">
                <input type="checkbox" bind:checked={nuevoCliente.activo}>
                Cliente activo
              </label>
            </div>
          </div>
        </section>
        <footer class="modal-card-foot">
          <button class="button is-success" onclick={agregarCliente}>Guardar Cliente</button>
          <button class="button" onclick={() => modalAgregarCliente = false}>Cancelar</button>
        </footer>
      </div>
    </div>
  
    <!-- Modal para asignar crédito -->
    {#if clienteSeleccionado}
      <div class="modal" class:is-active={modalCredito}>
        <div class="modal-background" onclick={() => modalCredito = false}></div>
        <div class="modal-card">
          <header class="modal-card-head">
            <p class="modal-card-title">Gestión de Crédito</p>
            <button class="delete" aria-label="close" onclick={() => modalCredito = false}></button>
          </header>
          <section class="modal-card-body">
            <div class="content">
              <p><strong>Cliente:</strong> {clienteSeleccionado.nombre}</p>
              <p><strong>RFC:</strong> {clienteSeleccionado.rfc}</p>
              
              <div class="field">
                <label class="label">Límite de Crédito ($)</label>
                <div class="control">
                  <input 
                    class="input" 
                    type="number" 
                    min="0" 
                    bind:value={clienteSeleccionado.credito.limite}
                  >
                </div>
              </div>
              
              <div class="field">
                <label class="label">Días de Crédito</label>
                <div class="control">
                  <input 
                    class="input" 
                    type="number" 
                    min="0" 
                    bind:value={clienteSeleccionado.credito.diasCredito}
                  >
                </div>
              </div>
              
              <div class="notification is-info is-light">
                <p>El crédito disponible se calculará automáticamente restando las compras pendientes de pago.</p>
                {#if clienteSeleccionado.credito.limite > 0}
                  <p>Crédito disponible actual: ${clienteSeleccionado.credito.disponible.toFixed(2)}</p>
                {/if}
              </div>
            </div>
          </section>
          <footer class="modal-card-foot">
            <button class="button is-primary" onclick={() => {}}>
              Guardar Cambios
            </button>
            <button class="button" onclick={() => modalCredito = false}>Cancelar</button>
          </footer>
        </div>
      </div>
    {/if}
  </div>
  
  <style>
    .table-container {
      max-height: 70vh;
      overflow-y: auto;
    }
    
    .buttons .button {
      margin-bottom: 0.25rem;
    }
    
    .tag {
      margin-bottom: 0;
    }
  </style>