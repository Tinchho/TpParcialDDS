import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import java.util.ArrayList

class RepoTaxis {
	static RepoTaxis instance
	@Accessors SistemaGeografico sistemaGeo
	@Accessors List<Taxi> taxistas = new ArrayList<Taxi>()

	def static getInstance() {
		if (instance == null) {
			instance = new RepoTaxis()
		}
		return instance
	}
	
	def static reinicar(){
		instance = null
	}

	def agregar(Taxi taxi) {
		if (!taxistas.contains(taxi)) {
			taxistas.add(taxi)
		}
	}

	def List<Taxi> obtenerTaxisEnAreaOrdenados(Cliente cliente) {
		val taxistasCercanos = taxistas.filter [ taxi |
				(sistemaGeo.obtenerArea(taxi.ubicacion) == sistemaGeo.obtenerArea(cliente.ubicacion)) &&
				taxi.estado == EstadoTaxi.Libre]
		val taxisOrdenados	= taxistasCercanos.sortBy[taxi|sistemaGeo.distanciaEntre(cliente.ubicacion,taxi.ubicacion)]
		return taxisOrdenados	
	}

}
