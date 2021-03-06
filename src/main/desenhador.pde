class Desenhador {
  float camera_x;
  Mundo mundo_clone;

  float seta_x1, seta_x2, seta_y, seta_largura, seta_altura;
  
  public void desenhar(Mundo mundo, Camera camera_obj) {

    float camera_x = camera_obj.get_pos();
    this.camera_x = camera_x;
    // a ideia é que mundo clone seja objeto-copia de mundo, e não uma referencia, assim pode mandar pra outra thread sem problemas
    // mas já que não tem como mandar pra outras thread, pelo menos o acesso pela thread de atualizar não fica concorrido com essa
    // de desenho, já que ficam dois objetos distintos na memoria (mas isso pode causar um problema de memoria, por isso vamo ficando
    // com a referencia do mesmo numero por agora)
    this.mundo_clone = mundo;
    this.desenhar_mundo(this.mundo_clone);
  }
  
  private void desenhar_mundo(Mundo mundo) {
    boolean tem_popup = false;
    //desenha o piso, sabendo se o tile tá com um popup aberto
    for (Tile tile : mundo.tiles) {
      tem_popup |= this.desenhar_tile(tile); //faz um OR com todo mundo pra saber se tem um popup ativo
    }

    if(!tem_popup) { // se não tiver popup
      //desenha os inimigos
      for(Inimigo i: mundo.inimigos) {
        this.desenhar_inimigo(i);
      }
      //desenha o player
      this.desenhar_player(mundo.player);
    }
  }

  private boolean desenhar_tile(Tile tile) {

    boolean retorno_popup = false;
    tile.x  = tile.num_tile * tile.tamanho - this.camera_x; // Calcula posição do tile no eixo x
    if((tile.x + tile.tamanho < 0 || tile.x > width) || (tile.y + tile.tamanho < 0 || tile.y > height)) { return retorno_popup; }

    //codigo provisorio pra desenhar o chão
    fill(tile.r, tile.g, tile.b);
    strokeWeight(0);
    rect(tile.x, tile.y, tile.tamanho, tile.tamanho);
    noFill();

    // se não tem estrutura aqui, não desenha ela
    if(tile.estrutura != null) {
      // Lugar daquela estrutura
      tile.estrutura.x_off = tile.x;
      tile.estrutura.y_off = tile.y;
      this.desenhar_estrutura(tile.estrutura);
    }

    return retorno_popup; //TODO: verificar popups
  }


  
  private void desenhar_inimigo(Inimigo inimigo) {
    //TODO: fazer tudo
  }

  private void desenhar_player(Player player) {
    //TODO: verificar se tá na tela

    this.desenhar_setas_player(player);
    fill(70, 80, 0);
    stroke(255, 0, 0);
    ellipse(player.x - this.camera_x, player.y, player.tamanho, player.tamanho);
  }

  private void desenhar_setas_player(Player player) {
    pushMatrix(); // tudo entre isso e o popmatrix vai ser descartado
    scale(-1, 1); // pra rodar a imagem em 180º no x
    image(player.seta_img, player.seta_esq_x, player.seta_y_off, player.seta_largura_img, player.seta_altura_img); //desenha a imagem
    popMatrix(); // descarta o scale e mas a seta fica renderizada
    image(player.seta_img, player.seta_dir_x, player.seta_y_off, player.seta_largura_img, player.seta_altura_img);

    this.seta_largura = player.seta_largura_img;
    this.seta_altura = player.seta_altura_img;
    
    this.seta_y = player.seta_y_off;

    this.seta_x1 = player.seta_esq_x + 2* this.seta_largura;
    this.seta_x2 = player.seta_dir_x;
  }

  public boolean mouse_na_regiao_controles() {
    boolean retorno = false;
    float x = mouseX;
    float y = mouseY;

    // x e y estão na seta da esqueda de controle de movimento do player?
    retorno |= (x > this.seta_x1 && x < this.seta_x1 + this.seta_largura)
      && (y > this.seta_y && y < this.seta_y + this.seta_altura);

    // x e y estão na seta da direita de controle de movimento do player?
    retorno |= (x > this.seta_x2 && x < this.seta_x2 + this.seta_largura)
      && (y > this.seta_y && y < this.seta_y + this.seta_altura);

    return retorno;
    
  }



  private boolean desenhar_estrutura(Estrutura estrutura) {
    //TODO: verificar se ta dentro da tela (mesmo que a tile já tenha feito isso?)


    if(estrutura.tipo == Tipo_Estrutura.BASE) { return this.desenhar_base((Base) estrutura); }
    if(estrutura.tipo == Tipo_Estrutura.MINA) { return this.desenhar_mina((Mina) estrutura); }
    if(estrutura.tipo == Tipo_Estrutura.TORRE) { return this.desenhar_torre((Torre) estrutura); }

    return true;
  }

  private boolean desenhar_base(Base base) {
    //provisorio
    fill(180, 170, 170);
    strokeWeight(0);
    float tamanho = 50;
    rect(base.x_off + Tile.tamanho / 4, base.y_off - tamanho, Tile.tamanho/2, tamanho);
    noFill();
    return false;
  }

  private boolean desenhar_mina(Mina mina) {
    //TODO: fazer tudo

    return false;
  }

  private boolean desenhar_torre(Torre torre) {
    //TODO: fazer tudo
    
    return false;
  }

  private void desenhar_projetil(Projetil projetil) {
    stroke(255, 200, 200); fill(255, 200, 200);
    float ponta_x = projetil.x - projetil.tamanho * cos(projetil.angulo);
    float ponta_y = projetil.y - projetil.tamanho * sin(projetil.angulo);
    line(projetil.x + -this.camera_x, projetil.y, ponta_x + -this.camera_x, ponta_y);
  }
  
}
