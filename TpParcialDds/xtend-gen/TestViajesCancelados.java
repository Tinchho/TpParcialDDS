import java.util.List;
import org.eclipse.xtext.xbase.lib.Conversions;
import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Matchers;
import org.mockito.Mockito;
import org.mockito.stubbing.OngoingStubbing;
import org.mockito.verification.VerificationMode;

@SuppressWarnings("all")
public class TestViajesCancelados {
  private Cliente pasajero = new Cliente();
  
  private Taxi taxi1 = new Taxi();
  
  private Area zonaOeste = new Area();
  
  private Area capitalFdral = new Area();
  
  private SistemaGeografico mockSistemaGeografico = Mockito.<SistemaGeografico>mock(SistemaGeografico.class);
  
  private Notificador mockNotificador = Mockito.<Notificador>mock(Notificador.class);
  
  @Before
  public void setUp() {
    this.pasajero.setNotificador(this.mockNotificador);
    RepoTaxis _instance = RepoTaxis.getInstance();
    _instance.setSistemaGeo(this.mockSistemaGeografico);
    this.taxi1.setEstado(EstadoTaxi.Libre);
    RepoTaxis _instance_1 = RepoTaxis.getInstance();
    _instance_1.agregar(this.taxi1);
    Ubicacion _any = Matchers.<Ubicacion>any(Ubicacion.class);
    Area _obtenerArea = this.mockSistemaGeografico.obtenerArea(_any);
    OngoingStubbing<Area> _when = Mockito.<Area>when(_obtenerArea);
    OngoingStubbing<Area> _thenReturn = _when.thenReturn(this.zonaOeste);
    _thenReturn.thenReturn(this.zonaOeste);
  }
  
  @After
  public void reinicarRepo() {
    RepoTaxis.reinicar();
  }
  
  @Test
  public void TestSolicitaViajeYCancelaAntesDeQueAcepten() {
    Viaje viaje = this.pasajero.solicitarViaje();
    List<Taxi> _taxisPosibles = viaje.getTaxisPosibles();
    int _length = ((Object[])Conversions.unwrapArray(_taxisPosibles, Object.class)).length;
    Assert.assertEquals(_length, 1);
    EstadoViaje _estado = viaje.getEstado();
    Assert.assertEquals(_estado, EstadoViaje.Solicitado);
    this.pasajero.cancelarViaje();
    EstadoViaje _estado_1 = viaje.getEstado();
    Assert.assertEquals(_estado_1, EstadoViaje.Cancelado);
  }
  
  @Test
  public void TestSolicitaViajeYCancelaDespuesDeQueAcepten() {
    Viaje viaje = this.pasajero.solicitarViaje();
    List<Taxi> _taxisPosibles = viaje.getTaxisPosibles();
    int _length = ((Object[])Conversions.unwrapArray(_taxisPosibles, Object.class)).length;
    Assert.assertEquals(_length, 1);
    this.taxi1.aceptarViaje(viaje);
    EstadoViaje _estado = viaje.getEstado();
    Assert.assertEquals(_estado, EstadoViaje.Aceptado);
    this.pasajero.cancelarViaje();
    EstadoViaje _estado_1 = viaje.getEstado();
    Assert.assertEquals(_estado_1, EstadoViaje.Cancelado);
    VerificationMode _times = Mockito.times(1);
    Notificador _verify = Mockito.<Notificador>verify(this.mockNotificador, _times);
    _verify.notificarCancelacionATaxi(this.taxi1);
  }
  
  @Test
  public void TestSolicitaViajeYCancelaElTaxistaDespuesDeQueAcepte() {
    Viaje viaje = this.pasajero.solicitarViaje();
    List<Taxi> _taxisPosibles = viaje.getTaxisPosibles();
    int _length = ((Object[])Conversions.unwrapArray(_taxisPosibles, Object.class)).length;
    Assert.assertEquals(_length, 1);
    this.taxi1.aceptarViaje(viaje);
    EstadoViaje _estado = viaje.getEstado();
    Assert.assertEquals(_estado, EstadoViaje.Aceptado);
    this.taxi1.cancelarViaje();
    EstadoViaje _estado_1 = viaje.getEstado();
    Assert.assertEquals(_estado_1, EstadoViaje.Cancelado);
    VerificationMode _times = Mockito.times(1);
    Notificador _verify = Mockito.<Notificador>verify(this.mockNotificador, _times);
    _verify.notificarCancelacionACliente(this.pasajero);
  }
}
