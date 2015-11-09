import static org.mockito.Mockito.*;
import org.junit.Before
import org.junit.Test
import org.junit.After
import org.junit.Assert

class TestViajesCancelados {
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

		taxi1.estado = EstadoTaxi.Libre

		RepoTaxis.getInstance.agregar(taxi1)

		when(mockSistemaGeografico.obtenerArea(any(Ubicacion))).thenReturn(zonaOeste).thenReturn(zonaOeste)

	}

	@After
	def void reinicarRepo() {
		RepoTaxis.reinicar
	}

	@Test
	def void TestSolicitaViajeYCancelaAntesDeQueAcepten() {

		var viaje = pasajero.solicitarViaje()

		//Verifico que hay taxi en mi zona
		Assert.assertEquals(viaje.taxisPosibles.length, 1)

		//Verifico el estado del viaje
		Assert.assertEquals(viaje.estado, EstadoViaje.Solicitado)

		//Cancelo el viaje
		pasajero.cancelarViaje()

		//Verifico el estado del viaje nuevamente
		Assert.assertEquals(viaje.estado, EstadoViaje.Cancelado)

	}
	
	@Test
	def void TestSolicitaViajeYCancelaDespuesDeQueAcepten() {

		var viaje = pasajero.solicitarViaje()

		//Verifico que hay taxi en mi zona
		Assert.assertEquals(viaje.taxisPosibles.length, 1)

		//Acepta el viaje
		taxi1.aceptarViaje(viaje)

		//Verifico el estado del viaje
		Assert.assertEquals(viaje.estado, EstadoViaje.Aceptado)

		//Cancelo el viaje
		pasajero.cancelarViaje()

		//Verifico el estado del viaje nuevamente
		Assert.assertEquals(viaje.estado, EstadoViaje.Cancelado)
		
		//Verfirico que se notifique al taxista
		verify(mockNotificador, times(1)).notificarCancelacionATaxi(taxi1)

	}
	
	@Test
	def void TestSolicitaViajeYCancelaElTaxistaDespuesDeQueAcepte() {

		var viaje = pasajero.solicitarViaje()

		//Verifico que hay taxi en mi zona
		Assert.assertEquals(viaje.taxisPosibles.length, 1)

		//Acepta el viaje
		taxi1.aceptarViaje(viaje)

		//Verifico el estado del viaje
		Assert.assertEquals(viaje.estado, EstadoViaje.Aceptado)

		//Cancelo el viaje
		taxi1.cancelarViaje()

		//Verifico el estado del viaje nuevamente
		Assert.assertEquals(viaje.estado, EstadoViaje.Cancelado)
		
		//Verfirico que se notifique al cliente
		verify(mockNotificador, times(1)).notificarCancelacionACliente(pasajero)

	}
}
