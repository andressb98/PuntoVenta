<script lang="ts">
    // Tipos
    type Proveedor = {
      id: number;
      nombre: string;
      rfc: string;
      direccion: string;
      telefono: string;
      email: string;
      productos: string[];
      activo: boolean;
    };
  
    // Estado
    let proveedores: Proveedor[] = [
      {
        id: 1,
        nombre: "Tecnologías Avanzadas SA de CV",
        rfc: "TAV1203456789",
        direccion: "Av. Tecnología 123, Ciudad de México",
        telefono: "5551234567",
        email: "contacto@tecnologiasavanzadas.com",
        productos: ["Laptops", "Monitores", "Teclados"],
        activo: true
      },
      {
        id: 2,
        nombre: "Suministros de Oficina Integrales",
        rfc: "SOI9876543210",
        direccion: "Calle Papelería 456, Guadalajara",
        telefono: "3339876543",
        email: "ventas@suministrosintegrales.com",
        productos: ["Papelería", "Mobiliario", "Artículos de escritorio"],
        activo: true
      },
      {
        id: 3,
        nombre: "Distribuidora de Alimentos Norte",
        rfc: "DAN4567890123",
        direccion: "Boulevard Alimenticio 789, Monterrey",
        telefono: "8187654321",
        email: "info@alimentosnorte.com",
        productos: ["Bebidas", "Snacks", "Cafetería"],
        activo: false
      }
    ];
  
    let busqueda: string = "";
    let modalAgregarProveedor = false;
    let modalEditarProveedor = false;
    let proveedorSeleccionado: Proveedor | null = null;
    let nuevoProveedor: Omit<Proveedor, "id"> = {
      nombre: "",
      rfc: "",
      direccion: "",
      telefono: "",
      email: "",
      productos: [],
      activo: true
    };
    let nuevoProductoProveedor = "";
  
    // Funciones
    function agregarProveedor() {
      if (nuevoProveedor.nombre && nuevoProveedor.rfc) {
        const nuevoId = Math.max(...proveedores.map(p => p.id), 0) + 1;
        proveedores = [...proveedores, { id: nuevoId, ...nuevoProveedor }];
        resetearFormulario();
        modalAgregarProveedor = false;
      }
    }
  
    function editarProveedor() {
      if (proveedorSeleccionado) {
        proveedores = proveedores.map(p => 
          p.id === proveedorSeleccionado?.id ? proveedorSeleccionado : p
        );
        modalEditarProveedor = false;
      }
    }
  
    function eliminarProveedor(id: number) {
      proveedores = proveedores.filter(p => p.id !== id);
    }
  
    function toggleEstadoProveedor(id: number) {
      proveedores = proveedores.map(p => 
        p.id === id ? { ...p, activo: !p.activo } : p
      );
    }
  
    function prepararEdicion(proveedor: Proveedor) {
      proveedorSeleccionado = JSON.parse(JSON.stringify(proveedor));
      modalEditarProveedor = true;
    }
  
    function agregarProductoAProveedor() {
      if (proveedorSeleccionado && nuevoProductoProveedor) {
        proveedorSeleccionado = {
          ...proveedorSeleccionado,
          productos: [...proveedorSeleccionado.productos, nuevoProductoProveedor]
        };
        nuevoProductoProveedor = "";
      }
    }
  
    function eliminarProductoDeProveedor(producto: string) {
      if (proveedorSeleccionado) {
        proveedorSeleccionado = {
          ...proveedorSeleccionado,
          productos: proveedorSeleccionado.productos.filter(p => p !== producto)
        };
      }
    }
  
    function resetearFormulario() {
      nuevoProveedor = {
        nombre: "",
        rfc: "",
        direccion: "",
        telefono: "",
        email: "",
        productos: [],
        activo: true
      };
    }
  
    // Filtrado
    $: proveedoresFiltrados = proveedores.filter(p =>
      p.nombre.toLowerCase().includes(busqueda.toLowerCase()) ||
      p.rfc.toLowerCase().includes(busqueda.toLowerCase())
    );
  </script>
  
  <div class="container py-4">
    <h1 class="title is-2">Gestión de Proveedores</h1>
  
    <!-- Barra de búsqueda y acciones -->
    <div class="level">
      <div class="level-left">
        <div class="level-item">
          <div class="field has-addons">
            <div class="control">
              <input
                class="input"
                type="text"
                placeholder="Buscar proveedores..."
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
          <button class="button is-primary" onclick={() => modalAgregarProveedor = true}>
            <span class="icon">
              <i class="fas fa-plus"></i>
            </span>
            <span>Nuevo Proveedor</span>
          </button>
        </div>
      </div>
    </div>
  
    <!-- Tabla de proveedores -->
    <div class="box">
      <div class="table-container">
        <table class="table is-fullwidth is-hoverable is-striped">
          <thead>
            <tr>
              <th>Nombre</th>
              <th>RFC</th>
              <th>Contacto</th>
              <th>Productos</th>
              <th>Estado</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            {#each proveedoresFiltrados as proveedor (proveedor.id)}
              <tr>
                <td>
                  <p class="has-text-weight-bold">{proveedor.nombre}</p>
                  <p class="is-size-7 has-text-grey">{proveedor.direccion}</p>
                </td>
                <td>{proveedor.rfc}</td>
                <td>
                  <p>{proveedor.telefono}</p>
                  <p class="is-size-7 has-text-grey">{proveedor.email}</p>
                </td>
                <td>
                  <div class="tags">
                    {#each proveedor.productos as producto}
                      <span class="tag is-light is-small">{producto}</span>
                    {/each}
                  </div>
                </td>
                <td>
                  <span class="tag {proveedor.activo ? 'is-success' : 'is-danger'}">
                    {proveedor.activo ? 'Activo' : 'Inactivo'}
                  </span>
                </td>
                <td>
                  <div class="buttons are-small">
                    <button class="button is-info is-light" onclick={() => prepararEdicion(proveedor)}>
                      <span class="icon">
                        <i class="fas fa-edit"></i>
                      </span>
                    </button>
                    <button class="button is-danger is-light" onclick={() => eliminarProveedor(proveedor.id)}>
                      <span class="icon">
                        <i class="fas fa-trash"></i>
                      </span>
                    </button>
                    <button 
                      class="button {proveedor.activo ? 'is-warning' : 'is-success'} is-light" 
                      onclick={() => toggleEstadoProveedor(proveedor.id)}
                    >
                      <span class="icon">
                        <i class="fas {proveedor.activo ? 'fa-toggle-off' : 'fa-toggle-on'}"></i>
                      </span>
                      <span>{proveedor.activo ? 'Desactivar' : 'Activar'}</span>
                    </button>
                  </div>
                </td>
              </tr>
            {/each}
          </tbody>
        </table>
      </div>
    </div>
  
    <!-- Modal para agregar proveedor -->
    <div class="modal" class:is-active={modalAgregarProveedor}>
      <div class="modal-background" onclick={() => modalAgregarProveedor = false}></div>
      <div class="modal-card">
        <header class="modal-card-head">
          <p class="modal-card-title">Agregar Nuevo Proveedor</p>
          <button class="delete" aria-label="close" onclick={() => modalAgregarProveedor = false}></button>
        </header>
        <section class="modal-card-body">
          <div class="field">
            <label class="label">Nombre del Proveedor*</label>
            <div class="control">
              <input class="input" type="text" placeholder="Nombre completo" bind:value={nuevoProveedor.nombre} required>
            </div>
          </div>
          
          <div class="columns">
            <div class="column">
              <div class="field">
                <label class="label">RFC*</label>
                <div class="control">
                  <input class="input" type="text" placeholder="RFC" bind:value={nuevoProveedor.rfc} required>
                </div>
              </div>
            </div>
            <div class="column">
              <div class="field">
                <label class="label">Teléfono*</label>
                <div class="control">
                  <input class="input" type="tel" placeholder="Teléfono" bind:value={nuevoProveedor.telefono} required>
                </div>
              </div>
            </div>
          </div>
          
          <div class="field">
            <label class="label">Dirección</label>
            <div class="control">
              <input class="input" type="text" placeholder="Dirección completa" bind:value={nuevoProveedor.direccion}>
            </div>
          </div>
          
          <div class="field">
            <label class="label">Correo Electrónico</label>
            <div class="control">
              <input class="input" type="email" placeholder="email@proveedor.com" bind:value={nuevoProveedor.email}>
            </div>
          </div>
          
          <div class="field">
            <label class="label">Productos que provee</label>
            <div class="field has-addons">
              <div class="control is-expanded">
                <input 
                  class="input" 
                  type="text" 
                  placeholder="Agregar producto" 
                  bind:value={nuevoProductoProveedor}
                  onkeydown={(e) => e.key === 'Enter' && agregarProductoAProveedor()}
                >
              </div>
              <div class="control">
                <button class="button is-info" onclick={agregarProductoAProveedor}>
                  <span class="icon">
                    <i class="fas fa-plus"></i>
                  </span>
                </button>
              </div>
            </div>
            <div class="tags mt-2">
              {#each nuevoProveedor.productos as producto}
                <span class="tag is-light">
                  {producto}
                  <button class="delete is-small" onclick={() => nuevoProveedor.productos = nuevoProveedor.productos.filter(p => p !== producto)}></button>
                </span>
              {/each}
            </div>
          </div>
          
          <div class="field">
            <div class="control">
              <label class="checkbox">
                <input type="checkbox" bind:checked={nuevoProveedor.activo}>
                Proveedor activo
              </label>
            </div>
          </div>
        </section>
        <footer class="modal-card-foot">
          <button class="button is-success" onclick={agregarProveedor}>Guardar Proveedor</button>
          <button class="button" onclick={() => modalAgregarProveedor = false}>Cancelar</button>
        </footer>
      </div>
    </div>
  
    <!-- Modal para editar proveedor -->
    {#if proveedorSeleccionado}
      <div class="modal" class:is-active={modalEditarProveedor}>
        <div class="modal-background" onclick={() => modalEditarProveedor = false}></div>
        <div class="modal-card">
          <header class="modal-card-head">
            <p class="modal-card-title">Editar Proveedor</p>
            <button class="delete" aria-label="close" onclick={() => modalEditarProveedor = false}></button>
          </header>
          <section class="modal-card-body">
            <div class="field">
              <label class="label">Nombre del Proveedor*</label>
              <div class="control">
                <input class="input" type="text" bind:value={proveedorSeleccionado.nombre} required>
              </div>
            </div>
            
            <div class="columns">
              <div class="column">
                <div class="field">
                  <label class="label">RFC*</label>
                  <div class="control">
                    <input class="input" type="text" bind:value={proveedorSeleccionado.rfc} required>
                  </div>
                </div>
              </div>
              <div class="column">
                <div class="field">
                  <label class="label">Teléfono*</label>
                  <div class="control">
                    <input class="input" type="tel" bind:value={proveedorSeleccionado.telefono} required>
                  </div>
                </div>
              </div>
            </div>
            
            <div class="field">
              <label class="label">Dirección</label>
              <div class="control">
                <input class="input" type="text" bind:value={proveedorSeleccionado.direccion}>
              </div>
            </div>
            
            <div class="field">
              <label class="label">Correo Electrónico</label>
              <div class="control">
                <input class="input" type="email" bind:value={proveedorSeleccionado.email}>
              </div>
            </div>
            
            <div class="field">
              <label class="label">Productos que provee</label>
              <div class="field has-addons">
                <div class="control is-expanded">
                  <input 
                    class="input" 
                    type="text" 
                    placeholder="Agregar producto" 
                    bind:value={nuevoProductoProveedor}
                    onkeydown={(e) => e.key === 'Enter' && agregarProductoAProveedor()}
                  >
                </div>
                <div class="control">
                  <button class="button is-info" onclick={agregarProductoAProveedor}>
                    <span class="icon">
                      <i class="fas fa-plus"></i>
                    </span>
                  </button>
                </div>
              </div>
              <div class="tags mt-2">
                {#each proveedorSeleccionado.productos as producto}
                  <span class="tag is-light">
                    {producto}
                    <button class="delete is-small" onclick={() => eliminarProductoDeProveedor(producto)}></button>
                  </span>
                {/each}
              </div>
            </div>
            
            <div class="field">
              <div class="control">
                <label class="checkbox">
                  <input type="checkbox" bind:checked={proveedorSeleccionado.activo}>
                  Proveedor activo
                </label>
              </div>
            </div>
          </section>
          <footer class="modal-card-foot">
            <button class="button is-success" onclick={editarProveedor}>Guardar Cambios</button>
            <button class="button" onclick={() => modalEditarProveedor = false}>Cancelar</button>
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
    
    .tags {
      flex-wrap: wrap;
      gap: 0.5rem;
    }
  </style>