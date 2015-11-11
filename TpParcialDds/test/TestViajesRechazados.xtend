import static org.mockito.Mockito.*;
import org.junit.Before
import org.junit.Test
import org.junit.After
import org.junit.Assert


class TestViajesRechazados {
	var pasajero = new Cliente()
	var taxi1 = new Taxi()

	var zonaOeste = new Area()
	var capitalFdral = new Area()
	var mockSistemaGeografico = mock(typeof(SistemaGeografico))
	var mockNotificador = mock(typeof(Notificador))

	@Before
	def void setUp() {
		pasajero.notificador = mockNotificador
		RepoTaxis.getInstance.sistemaGeo = mockSistemaGeografico

		pasajero.telefono = 147258
		taxi1.estado = EstadoTaxi.Libre
		taxi1.telefono = 123456
		taxi1.notificador =mockNotificador

		RepoTaxis.getInstance.agregar(taxi1)

	}

	@After
	def void reinicarRepo() {
		RepoTaxis.reinicar
	}

	@Test
	def void TestNingunTaxiEnMiAreaSeRechazaViaje() {
		
		//Seteo lo que deberia devolver el sistema geografico
		when(mockSistemaGeografico.obtenerArea(any(Ubicacion))).thenReturn(zonaOeste).thenReturn(capitalFdral)
		
		var viaje = pasajero.solicitarViaje()

		//Verifico que ningun taxi esta en mi zona
		Assert.assertEquals(viaje.taxisPosibles.length, 0)

		//Verifico el estado del viaje
		Assert.assertEquals(viaje.estado, EstadoViaje.Rechazado)

		//Verifico que se notifique al cliente
		verify(mockNotificador, times(1)).notificar(any(int),any(String))
	}
	
	
	@Test
	def void TestHayUnTaxiEnMiZonaPeroRechaza(){
		when(mockSistemaGeografico.obtenerArea(any(Ubicacion))).thenReturn(zonaOeste).thenReturn(zonaOeste)
		
		var viaje = pasajero.solicitarViaje()

		//Verifico que hay un taxi en mi zona
		Assert.assertEquals(viaje.taxisPosibles.length, 1)
		
		//El taxi rechaza el viaje
		taxi1.rechazarViaje()
		
		//Verifico que se rechaza el viaje
		verify(mockNotificador, times(2)).notificar(any(int),any(String))
		Assert.assertEquals(viaje.estado, EstadoViaje.Rechazado)
	}

}
