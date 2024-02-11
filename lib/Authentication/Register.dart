import 'package:flutter/material.dart';
import 'package:rickshaw2/Authentication/Login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          SizedBox(
            width: 250,
            height: 250,
            child:Image.asset("assets/images/icon.jpg"),
          ),
    SizedBox(
      child: Text("Register to DigiRickshaw",style: TextStyle(fontSize:18)),
    ),SizedBox(height: 20,),
          Text("Fill the below Form"),
          SizedBox(height: 20,),
          SizedBox(
            width: 250,
            child: TextField(
              decoration: InputDecoration(
                label: Text("Email Address"),
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey,width: 2),borderRadius: BorderRadius.circular(10)),
              ),

            ),
          ),
          SizedBox(
            width: 250,
            child: TextField(
              decoration: InputDecoration(
                label: Text("Password"),
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey,width: 2),borderRadius: BorderRadius.circular(10)),
              ),

            ),
          ),
          
          ElevatedButton(onPressed: (){}, child: Text("Register"),style: ElevatedButton.styleFrom(backgroundColor: Colors.black)),
          SizedBox(height: 20,),
          Text("Already Signed Up?"),
          SizedBox(height: 10,),
          Text("Login"),
      ElevatedButton(onPressed: (){
        Navigator.
pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage(),), (route) => false);  }, child: Text("Register"),style:ElevatedButton.styleFrom(backgroundColor: Colors.black)),

        ],
      ),
    );
  }
}
