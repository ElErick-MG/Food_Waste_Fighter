package entities;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "receta")
public class Receta implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_receta")
    private Long idReceta;

    @Column(name = "nombre", nullable = false, length = 200)
    private String nombre;

    @Column(name = "descripcion", columnDefinition = "TEXT")
    private String descripcion;

    @Column(name = "imagen_url", length = 500)
    private String imagenUrl;

    @Column(name = "tiempo_preparacion", nullable = false)
    private Integer tiempoPreparacion; // En minutos

    @Column(name = "porciones", nullable = false)
    private Integer porciones;

    @Column(name = "dificultad", nullable = false, length = 50)
    private String dificultad;

    @OneToMany(mappedBy = "receta", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @OrderBy("orden ASC")
    private List<Ingrediente> ingredientes = new ArrayList<>();

    @OneToMany(mappedBy = "receta", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @OrderBy("numeroPaso ASC")
    private List<PasoPreparacion> pasos = new ArrayList<>();

    @OneToOne(mappedBy = "receta", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private InformacionNutricional informacionNutricional;

    // Constructors
    public Receta() {
    }

    public Receta(String nombre, String descripcion, String imagenUrl, Integer tiempoPreparacion, 
                  Integer porciones, String dificultad) {
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.imagenUrl = imagenUrl;
        this.tiempoPreparacion = tiempoPreparacion;
        this.porciones = porciones;
        this.dificultad = dificultad;
    }

    // Getters and Setters
    public Long getIdReceta() {
        return idReceta;
    }

    public void setIdReceta(Long idReceta) {
        this.idReceta = idReceta;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getImagenUrl() {
        return imagenUrl;
    }

    public void setImagenUrl(String imagenUrl) {
        this.imagenUrl = imagenUrl;
    }

    public Integer getTiempoPreparacion() {
        return tiempoPreparacion;
    }

    public void setTiempoPreparacion(Integer tiempoPreparacion) {
        this.tiempoPreparacion = tiempoPreparacion;
    }

    public Integer getPorciones() {
        return porciones;
    }

    public void setPorciones(Integer porciones) {
        this.porciones = porciones;
    }

    public String getDificultad() {
        return dificultad;
    }

    public void setDificultad(String dificultad) {
        this.dificultad = dificultad;
    }

    public List<Ingrediente> getIngredientes() {
        return ingredientes;
    }

    public void setIngredientes(List<Ingrediente> ingredientes) {
        this.ingredientes = ingredientes;
    }

    public List<PasoPreparacion> getPasos() {
        return pasos;
    }

    public void setPasos(List<PasoPreparacion> pasos) {
        this.pasos = pasos;
    }

    public InformacionNutricional getInformacionNutricional() {
        return informacionNutricional;
    }

    public void setInformacionNutricional(InformacionNutricional informacionNutricional) {
        this.informacionNutricional = informacionNutricional;
    }

    @Override
    public String toString() {
        return "Receta{id=" + idReceta + ", nombre='" + nombre + "', tiempo=" + tiempoPreparacion + " min}";
    }
}