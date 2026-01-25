package entities;

import jakarta.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;

@Entity
@Table(name = "informacion_nutricional")
public class InformacionNutricional implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_nutricional")
    private Long idNutricional;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_receta", nullable = false, unique = true)
    private Receta receta;

    @Column(name = "calorias", nullable = false)
    private Integer calorias;

    @Column(name = "grasas", nullable = false, precision = 5, scale = 1)
    private BigDecimal grasas;

    @Column(name = "carbohidratos", nullable = false, precision = 5, scale = 1)
    private BigDecimal carbohidratos;

    @Column(name = "proteinas", nullable = false, precision = 5, scale = 1)
    private BigDecimal proteinas;

    // Constructors
    public InformacionNutricional() {
    }

    public InformacionNutricional(Receta receta, Integer calorias, BigDecimal grasas, 
                                  BigDecimal carbohidratos, BigDecimal proteinas) {
        this.receta = receta;
        this.calorias = calorias;
        this.grasas = grasas;
        this.carbohidratos = carbohidratos;
        this.proteinas = proteinas;
    }

    // Getters and Setters
    public Long getIdNutricional() {
        return idNutricional;
    }

    public void setIdNutricional(Long idNutricional) {
        this.idNutricional = idNutricional;
    }

    public Receta getReceta() {
        return receta;
    }

    public void setReceta(Receta receta) {
        this.receta = receta;
    }

    public Integer getCalorias() {
        return calorias;
    }

    public void setCalorias(Integer calorias) {
        this.calorias = calorias;
    }

    public BigDecimal getGrasas() {
        return grasas;
    }

    public void setGrasas(BigDecimal grasas) {
        this.grasas = grasas;
    }

    public BigDecimal getCarbohidratos() {
        return carbohidratos;
    }

    public void setCarbohidratos(BigDecimal carbohidratos) {
        this.carbohidratos = carbohidratos;
    }

    public BigDecimal getProteinas() {
        return proteinas;
    }

    public void setProteinas(BigDecimal proteinas) {
        this.proteinas = proteinas;
    }

    @Override
    public String toString() {
        return "InformacionNutricional{calorias=" + calorias + ", grasas=" + grasas + 
               ", carbohidratos=" + carbohidratos + ", proteinas=" + proteinas + "}";
    }
}