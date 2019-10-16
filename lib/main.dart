// [x] Adicionar botões (Toggle ou Radio button) para escolha de gênero (masculino / feminino);
// [x] Corrigir o calculo de acordo com o gênero (masculino e feminino);
// [x] Criar um classe Pessoa com os atributos (peso, altura e gênero), criar métodos para calcular IMC e classificar;
// [x] Refatorar o código do aplicativo para utilizar a classe Pessoa;
// [x] Aplicar uma escala de cores para o resultado da classificação do IMC;
// [x] Aumentar o texto do resultado do IMC (número) e também colocar em negrito.

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';


//adicionando classe pessoa
class Pessoa{

  double peso = 0.0;
  double altura = 0.0;
  int genero = 0;

  double calcularIMC(){
    return this.peso / (this.altura/100 * this.altura/100);
  }
  Color buscarCorIdeal(double imc
) {  

//cor do resultado  
    Color cor;
    if (this.genero == 0){

      if (imc < 20.7)
        cor = Colors.blue;
      else if (imc >= 20.7 && imc <= 26.4)
        cor = Colors.green;
      else if (imc >= 26.5 && imc <= 27.8)
        cor = Colors.lime;
      else if (imc >= 27.9 && imc <= 31.1)
        cor = Colors.yellow;
      else
        cor = Colors.red;
    }

    else{

      if (imc < 19.1)
        cor = Colors.blue;
      else if (imc >= 19.1 && imc <= 25.8)
        cor = Colors.green;
      else if (imc >= 25.9 && imc <= 27.3)
        cor = Colors.lime;
      else if (imc >= 27.4 && imc <= 32.3)
        cor = Colors.yellow;
      else
        cor = Colors.red;
    }
    return cor;
  }

  String classificar(double imc){
    String _result = '';

//peso do homem
    if (this.genero == 0){

      if (imc < 20.7)
        _result += "Abaixo do peso";
      else if (imc >= 20.7 && imc <= 26.4)
        _result += "Peso ideal";
      else if (imc >= 26.5 && imc <= 27.8)
        _result += "Levemente acima do peso";
      else if (imc >= 27.9 && imc <= 31.1)
        _result += "Acima do peso";
      else
        _result += "Obesidade";

    }
    else{
//peso da mulher
      if (imc < 19.1)
        _result += "Abaixo do peso";
      else if (imc >= 19.1 && imc <= 25.8)
        _result += "Peso ideal";
      else if (imc >= 25.9 && imc <= 27.3)
        _result += "Levemente acima do peso";
      else if (imc >= 27.4 && imc <= 32.3)
        _result += "Acima do peso";
      else
        _result += "Obesidade";
    }
    return _result;
  }
}

void main() => runApp(MaterialApp(

  home: Home(),
  debugShowCheckedModeBanner: false,//baner de debug
  
  ));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin
 {

  TabController controller;
  TextEditingController _weightController = TextEditingController();//controla o peso
  TextEditingController _heightController = TextEditingController();//controla a altura
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  

  Pessoa usuario = Pessoa();
  String imcNumber = "0.0";
  String imcMessage = "Insira seus dados.";
  Color imcColor = Colors.grey;
  bool isResultOnScreen = false;
  double alt = 0.0;


  @override
  void initState() { //onde o app inicia.
    super.initState();
    controller = new TabController(vsync: this, length: 2);
    resetFields();
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  void resetFields() {
    //resetar os campos
    _weightController.text = '';
    _heightController.text = '';
    isResultOnScreen = false;

    setState(() {//altera a tela
      imcMessage = 'Insira seus dados.';
      imcNumber = "";
      imcColor = Colors.grey;
    });
  }

  void _calculodoGenero(int value){

    setState((){
      //mudança de tela
      if (isResultOnScreen){
        usuario.genero = value;

        imcMessage = usuario.classificar(usuario.calcularIMC());
        imcNumber = usuario.calcularIMC().toStringAsPrecision(3);
        imcColor = usuario.buscarCorIdeal(usuario.calcularIMC());
        
        
      }
    });
    usuario.genero = value;
  }

  TextFormField insert(String label, String warning, TextEditingController controller) {
    //campo de entrada

    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label,
      hintText: 'insira seu peso',
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
      maxLength: 3,
      controller: controller,
      validator: (text) {
        return text.isEmpty ? warning : null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // app bar* nome e cor do app
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Calculadora IMC',
          textAlign: TextAlign.center,),
        
          backgroundColor: Colors.deepOrange,
          actions: <Widget>[

  
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                resetFields();
              },
            )
          ],
        ),



        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text('Gênero:',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400,
                            color: Colors.grey),
                      ),
                    ),
                    Row( 
                       //escolha de genero
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Radio(value: 0,
                          groupValue: usuario.genero,
                          onChanged: _calculodoGenero,
                        ),
                        Text('Masculino'),
                        Radio(value: 1,
                          groupValue: usuario.genero,
                          onChanged:  _calculodoGenero,
                          activeColor: Colors.red,
                        ),
                        Text('Feminino'),
                      ],),


                    insert("Altura (cm)", "Digite uma altura!", _heightController),
                    Padding(padding: EdgeInsets.only(top: 8.0),),
                    insert("Peso (kg)", "Digite um peso!", _weightController),



                    Padding(
                      //espaçamentos 
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(imcNumber, textAlign: TextAlign.center, style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold))
                    ),

                    Padding(
                      //espaçamentos 
                        padding: EdgeInsets.all(8),

                        child: Text(imcMessage, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: imcColor, ))
                    ),


                      new LinearPercentIndicator(
                      width: 370.0,
                      lineHeight: 2.0,
                      animation: true,
                      percent:  1,
                      backgroundColor: Colors.grey,
                      progressColor: imcColor,
                      ),

                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 36.0),


                        child: Container(
                            height: 50,
                            child: RaisedButton(
                              color: imcColor, //cor do botão
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            
                              onPressed: () {// resultados 

                                if (_formKey.currentState.validate()) {
                                  usuario.altura = double.parse(_heightController.text);
                                  usuario.peso = double.parse(_weightController.text);
                                  double resultado = usuario.calcularIMC();
                                  setState((){
                                    imcMessage = usuario.classificar(resultado);
                                    imcNumber = usuario.calcularIMC().toStringAsPrecision(3);
                                    imcColor = usuario.buscarCorIdeal(usuario.calcularIMC());
                                    isResultOnScreen = true;
                                  });
                                }
                              },
                             
                              child: Text('CALCULAR', style: TextStyle(color: Colors.white)),
                              
                              
                            ),
                            ),
                            ),
                ],
                ),
                ),
                ),
                );
                }
                }