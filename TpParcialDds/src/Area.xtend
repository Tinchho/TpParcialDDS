

import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList
import java.util.List

@Accessors
class Area {
	Area padre
	//FIXME cree esta lista para facilitarme verificar el area donde se encuentra el taxi o el usuario
	List<Ubicacion> ubicacionesDelArea = new ArrayList<Ubicacion>
}