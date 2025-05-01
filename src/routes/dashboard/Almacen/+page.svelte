<script lang="ts">
    // Tipos
    type Almacen = {
      id: number;
      nombre: string;
      ubicacion: string;
      capacidad: number;
      responsable: string;
      telefono: string;
      activo: boolean;
    };
  
    // Estado
    let almacenes: Almacen[] = [
      {
        id: 1,
        nombre: "Almacén Principal",
        ubicacion: "Av. Industrial 123, Zona Norte",
        capacidad: 5000,
        responsable: "Juan Pérez",
        telefono: "5551234567",
        activo: true
      },
      {
        id: 2,
        nombre: "Almacén Secundario",
        ubicacion: "Calle Almacenes 456, Zona Sur",
        capacidad: 3000,
        responsable: "María García",
        telefono: "5557654321",
        activo: true
      },
      {
        id: 3,
        nombre: "Bodega Refrigerada",
        ubicacion: "Boulevard Frío 789, Zona Este",
        capacidad: 1500,
        responsable: "Carlos López",
        telefono: "5559876543",
        activo: false
      }
    ];
  
    let busqueda: string = "";
    let modalAgregarAlmacen = false;
    let nuevoAlmacen: Omit<Almacen, "id"> = {
      nombre: "",
      ubicacion: "",
      capacidad: 0,
      responsable: "",
      telefono: "",
      activo: true
    };
  
    // Funciones
    function agregarAlmacen() {
      if (nuevoAlmacen.nombre && nuevoAlmacen.ubicacion) {
        const nuevoId = Math.max(...almacenes.map(a => a.id), 0) + 1;
        almacenes = [...almacenes, { id: nuevoId, ...nuevoAlmacen }];
        resetearFormulario();
        modalAgregarAlmacen = false;
      }
    }
  
    function toggleEstadoAlmacen(id: number) {
      almacenes = almacenes.map(a => 
        a.id === id ? { ...a, activo: !a.activo } : a
      );
    }
  
    function resetearFormulario() {
      nuevoAlmacen = {
        nombre: "",
        ubicacion: "",
        capacidad: 0,
        responsable: "",
        telefono: "",
        activo: true
      };
    }
  
    // Filtrado
    $: almacenesFiltrados = almacenes.filter(a =>
      a.nombre.toLowerCase().includes(busqueda.toLowerCase()) ||
      a.ubicacion.toLowerCase().includes(busqueda.toLowerCase())
    );
  </script>
  
  <div class="container py-4">
    <h1 class="title is-2">Gestión de Almacenes</h1>
  
    <!-- Barra de búsqueda y acciones -->
    <div class="level">
      <div class="level-left">
        <div class="level-item">
          <div class="field has-addons">
            <div class="control">
              <input
                class="input"
                type="text"
                placeholder="Buscar almacenes..."
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
          <button class="button is-primary" onclick={() => modalAgregarAlmacen = true}>
            <span class="icon">
              <i class="fas fa-plus"></i>
            </span>
            <span>Nuevo Almacén</span>
          </button>
        </div>
      </div>
    </div>
  
    <!-- Tabla de almacenes -->
    <div class="box">
      <div class="table-container">
        <table class="table is-fullwidth is-hoverable is-striped">
          <thead>
            <tr>
              <th>Nombre</th>
              <th>Ubicación</th>
              <th>Capacidad</th>
              <th>Responsable</th>
              <th>Contacto</th>
              <th>Estado</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            {#each almacenesFiltrados as almacen (almacen.id)}
              <tr>
                <td class="has-text-weight-bold">{almacen.nombre}</td>
                <td>{almacen.ubicacion}</td>
                <td>{almacen.capacidad} m²</td>
                <td>{almacen.responsable}</td>
                <td>{almacen.telefono}</td>
                <td>
                  <span class="tag {almacen.activo ? 'is-success' : 'is-danger'}">
                    {almacen.activo ? 'Activo' : 'Inactivo'}
                  </span>
                </td>
                <td>
                  <div class="buttons are-small">
                    <button class="button is-info is-light" onclick={() => {}}>
                      <span class="icon">
                        <i class="fas fa-edit"></i>
                      </span>
                    </button>
                    <button 
                      class="button {almacen.activo ? 'is-warning' : 'is-success'} is-light" 
                      onclick={() => toggleEstadoAlmacen(almacen.id)}
                    >
                      <span class="icon">
                        <i class="fas {almacen.activo ? 'fa-toggle-off' : 'fa-toggle-on'}"></i>
                      </span>
                      <span>{almacen.activo ? 'Desactivar' : 'Activar'}</span>
                    </button>
                  </div>
                </td>
              </tr>
            {/each}
          </tbody>
        </table>
      </div>
    </div>
  
    <!-- Modal para agregar almacén -->
    <div class="modal" class:is-active={modalAgregarAlmacen}>
      <div class="modal-background" onclick={() => modalAgregarAlmacen = false}></div>
      <div class="modal-card">
        <header class="modal-card-head">
          <p class="modal-card-title">Agregar Nuevo Almacén</p>
          <button class="delete" aria-label="close" onclick={() => modalAgregarAlmacen = false}></button>
        </header>
        <section class="modal-card-body">
          <div class="field">
            <label class="label">Nombre del Almacén*</label>
            <div class="control">
              <input class="input" type="text" placeholder="Nombre identificador" bind:value={nuevoAlmacen.nombre} required>
            </div>
          </div>
          
          <div class="field">
            <label class="label">Ubicación*</label>
            <div class="control">
              <input class="input" type="text" placeholder="Dirección completa" bind:value={nuevoAlmacen.ubicacion} required>
            </div>
          </div>
          
          <div class="columns">
            <div class="column">
              <div class="field">
                <label class="label">Capacidad (m²)</label>
                <div class="control">
                  <input class="input" type="number" min="0" bind:value={nuevoAlmacen.capacidad}>
                </div>
              </div>
            </div>
            <div class="column">
              <div class="field">
                <label class="label">Teléfono Contacto</label>
                <div class="control">
                  <input class="input" type="tel" placeholder="Teléfono responsable" bind:value={nuevoAlmacen.telefono}>
                </div>
              </div>
            </div>
          </div>
          
          <div class="field">
            <label class="label">Responsable</label>
            <div class="control">
              <input class="input" type="text" placeholder="Nombre del responsable" bind:value={nuevoAlmacen.responsable}>
            </div>
          </div>
          
          <div class="field">
            <div class="control">
              <label class="checkbox">
                <input type="checkbox" bind:checked={nuevoAlmacen.activo}>
                Almacén activo
              </label>
            </div>
          </div>
        </section>
        <footer class="modal-card-foot">
          <button class="button is-success" onclick={agregarAlmacen}>Guardar Almacén</button>
          <button class="button" onclick={() => modalAgregarAlmacen = false}>Cancelar</button>
        </footer>
      </div>
    </div>
  </div>
  
  <style>
    .table-container {
      max-height: 70vh;
      overflow-y: auto;
    }
    
    .buttons .button {
      margin-bottom: 0.25rem;
    }
  </style>