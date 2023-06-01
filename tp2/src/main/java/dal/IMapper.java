package dal;

public interface IMapper<Tentity,Tkey>{

    Tkey create(Tentity e) throws Exception;

    Tentity read(Tkey k) throws Exception; // acesso dada a chave

    void update(Tentity e) throws Exception;

    void delete(Tentity e) throws Exception;
}