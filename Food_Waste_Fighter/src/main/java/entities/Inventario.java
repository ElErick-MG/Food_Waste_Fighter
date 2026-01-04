package entities;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "inventario")
public class Inventario implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_inventario")
    private Long idInventario;

    @OneToMany(mappedBy = "inventario", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Alimento> alimentos = new ArrayList<>();

    public Inventario() {
    }

    public Long getIdInventario() {
        return idInventario;
    }

    public void setIdInventario(Long idInventario) {
        this.idInventario = idInventario;
    }

    public List<Alimento> getAlimentos() {
        return alimentos;
    }

    public void setAlimentos(List<Alimento> alimentos) {
        this.alimentos = alimentos;
    }
}
