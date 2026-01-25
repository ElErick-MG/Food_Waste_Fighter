package entities;

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "paso_preparacion")
public class PasoPreparacion implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_paso")
    private Long idPaso;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_receta", nullable = false)
    private Receta receta;

    @Column(name = "numero_paso", nullable = false)
    private Integer numeroPaso;

    @Column(name = "titulo", nullable = false, length = 200)
    private String titulo;

    @Column(name = "descripcion", nullable = false, columnDefinition = "TEXT")
    private String descripcion;

    // Constructors
    public PasoPreparacion() {
    }

    public PasoPreparacion(Receta receta, Integer numeroPaso, String titulo, String descripcion) {
        this.receta = receta;
        this.numeroPaso = numeroPaso;
        this.titulo = titulo;
        this.descripcion = descripcion;
    }

    // Getters and Setters
    public Long getIdPaso() {
        return idPaso;
    }

    public void setIdPaso(Long idPaso) {
        this.idPaso = idPaso;
    }

    public Receta getReceta() {
        return receta;
    }

    public void setReceta(Receta receta) {
        this.receta = receta;
    }

    public Integer getNumeroPaso() {
        return numeroPaso;
    }

    public void setNumeroPaso(Integer numeroPaso) {
        this.numeroPaso = numeroPaso;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    @Override
    public String toString() {
        return "PasoPreparacion{id=" + idPaso + ", paso=" + numeroPaso + ", titulo='" + titulo + "'}";
    }
}