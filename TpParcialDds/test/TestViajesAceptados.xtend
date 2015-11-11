import static org.mockito.Mockito.*;
import org.junit.Before
import org.junit.Test
import org.junit.After
import org.junit.Assert


class TestViajesAceptados {
	var pasajero = new Cliente()
	var taxi1 = new Taxi()
	var taxi2 = new Taxi()
	var taxi3 = new Taxi()
	var granBsAs = new Area()
	var zonaOeste = new Area()
	var capitalFdral = new Area()
	var mockSistemaGeografico = mock(typeof(SistemaGeografico))
	var mockNotificador = mock(typeof(Notificador))

	@Before
	def void setUp() {
		pasajero.notificador = mockNotificador
		RepoTaxis.getInstance.sistemaGeo = mockSistemaGeografico

		zonaOeste.padre = granBsAs
		
		pasajero.telefono = 147258
		taxi1.estado = EstadoTaxi.Libre
		taxi1.telefono = 123456
		taxi1.notificador =mockNotificador
		taxi2.estado = EstadoTaxi.Libre
		taxi2.telefono = 654321
		taxi2.notificador =mockNotificador
		taxi3.estado = EstadoTaxi.Libre
		taxi3.telefono = 456789
		taxi3.notificador =mockNotificador

		RepoTaxis.getInstance.agregar(taxi1)
		RepoTaxis.getInstance.agregar(taxi2)
		RepoTaxis.getInstance.agregar(taxi3)

		//Seteo lo que deberia devolver el sistema geografico
		//Para el filter el taxi1 y el pasajero son de zonaOeste igual para el 2
		//Para el taxi3 es de cap federal y el usuario de zonOeste
		when(mockSistemaGeografico.obtenerArea(any(Ubicacion))).thenReturn(zonaOeste).thenReturn(zonaOeste).
			thenReturn(zonaOeste).thenReturn(zonaOeste).thenReturn(capitalFdral).thenReturn(zonaOeste)
		//Aca devuelvo que el mas cercano es el taxi2
		when(mockSistemaGeografico.distanciaEntre(any(Ubicacion), any(Ubicacion))).thenReturn(5).thenReturn(10)
	}

	@After
	def void reinicarRepo() {
		RepoTaxis.reinicar
	}

	@Test
	def void TestClientePideViaje() {
		pasajero.solicitarViaje()
		verify(mockNotificador, times(1)).notificar(any(int), any(String))
	}

	@Test
	def void TestClientePideViajeYAceptaUnTaxi() {
		var viaje = pasajero.solicitarViaje()
		
		//Verfico que se notifico al primer taxi
		verify(mockNotificador, times(1)).notificar(any(int), any(String))
		
		taxi2.aceptarViaje()
		
		//Verfico que se notifico al cliente que se acepto el viaje
		verify(mockNotificador, times(2)).notificar(any(int), any(String))
		
		//Verifico el estado del viaje
		Assert.assertEquals(viaje.estado,EstadoViaje.Aceptado)
		
		//Verfico que el taxi ahora se encuentra ocupado
		Assert.assertEquals(taxi2.estado,EstadoTaxi.Ocupado)
	}

	@Test
	def void TestClientePideViajeYRechazaTaxi2yAceptaTaxi1() {
		var viaje = pasajero.solicitarViaje()
		
		//Verifico que haya solo 2 de los 3 taxis estan en mi area
		Assert.assertEquals(pasajero.viajeActual.taxisPosibles.length, 2)
		
		//Verfico que la lista en este en orden, el mas cercano era el taxi2 como dije antes
		Assert.assertEquals(viaje.taxisPosibles.get(0), taxi2)
		Assert.assertEquals(viaje.taxisPosibles.get(1), taxi1)
		
		//Verfico que se haya notificado al taxi2 primero
		verify(mockNotificador, times(1)).notificar(any(int), any(String))
		
		//Taxi2 rechaza y se verifca que se notifique al taxi1 que es el siguiente mas cercano
		taxi2.rechazarViaje()
		verify(mockNotificador, times(2)).notificar(any(int), any(String))
		
		//Taxi1 acepta el viaje y verifico que se notifique al cliente
		taxi1.aceptarViaje()
		verify(mockNotificador, times(3)).notificar(any(int), any(String))
		Assert.assertEquals(viaje.taxisPosibles.length,1)

	}
	

}
