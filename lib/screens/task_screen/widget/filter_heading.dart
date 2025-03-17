





import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class FilterSearchField extends StatefulWidget {
  const FilterSearchField({
    super.key,

  });


  @override
  State<FilterSearchField> createState() => _FilterSearchFieldState();
}

class _FilterSearchFieldState extends State<FilterSearchField> {


  OverlayEntry? entry;
  final layerLink = LayerLink();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance!.addPostFrameCallback((_)=>showOverLay());
  }

  String filter = "new";

  void showOverLay(){
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    entry = OverlayEntry(
      builder: (context) => Positioned(
          width: size.width,
          child: CompositedTransformFollower(
              link: layerLink,
              showWhenUnlinked: false,
              offset: Offset(0,size.height-20),
              child: buildOverLay())),
    );
    overlay.insert(entry!);
  }


  Widget buildOverLay(){
    // filter = widget.controller.filterOption.value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.white
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sort by",style:TextStyle(
                        color: Colors.black,
                        fontWeight:FontWeight.w700,fontSize: 16,fontFamily: "Inter"
                    ),
                    ),
                    GestureDetector(
                        onTap: (){
                          if(entry!=null){
                            entry!.remove();
                            entry = null;
                          }
                        },
                        child: Icon(Icons.close,size: 25,)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                child: GestureDetector(
                  onTap: (){
                    if(filter!="new"){
                      filter = "new";


                      entry!.remove();
                      entry = null;
                    }
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 15,
                        width: 15,
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 2,
                                  spreadRadius: 1,
                                  color: Colors.grey,
                                  offset: Offset(1,0)
                              )
                            ]
                        ),
                        child:Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: filter=="new"?Colors.black:Colors.transparent
                          ),
                        ),
                      ),
                      SizedBox(width: 20,),
                      Text(
                        "Completed",style:TextStyle(
                          color: Colors.black,
                          fontWeight:FontWeight.w700,fontSize: 16,fontFamily: "Inter"
                      ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                child: GestureDetector(
                  onTap: (){
                    if(filter!="hlp"){
                      filter = "hlp";
                      // widget.controller.filterOption.value = "hlp";
                      // widget.controller.currentLimit.value = 10;
                      // widget.controller.loadMore.value=true;
                      // widget.controller.allProductList.clear();
                      // widget.controller.getAllProduct();
                      // widget.controller.businessProductList.clear();
                      // widget.controller.getProductBusiness();
                      // widget.controller.artistProductList.clear();
                      // widget.controller.getArtistBusiness();
                      entry!.remove();
                      entry = null;
                    }
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 15,
                        width: 15,
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 2,
                                  spreadRadius: 1,
                                  color: Colors.grey,
                                  offset: Offset(1,0)
                              )
                            ]
                        ),
                        child:Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: filter=="hlp"?Colors.black:Colors.transparent
                          ),
                        ),
                      ),
                      SizedBox(width: 20,),
                      Text(
                        "Pending",style:TextStyle(
                          color: Colors.black,
                          fontWeight:FontWeight.w700,fontSize: 16,fontFamily: "Inter"
                      ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10,)
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return CompositedTransformTarget(
      link: layerLink,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 0,right:0,top: 20,bottom: 20),
              child: Container(
                height: 40,
                alignment: Alignment.centerLeft,
                width:width*0.78,
                child: Text("Todo List",style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,fontWeight: FontWeight.bold
                ),),
              ),
            ),
            Expanded(child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 8,
                        spreadRadius: 1,
                        color: Colors.grey,
                        offset: Offset(1,0)
                    )
                  ]
              ),
              child: GestureDetector(
                  onTap: (){
                    if(entry!=null){
                      entry!.remove();
                      entry = null;
                    } else{
                      showOverLay();
                    }
                  },
                  child: Icon(Icons.filter_list_sharp,size: 30,color: Colors.black,)),
            ))
          ],
        ),
      ),
    );
  }
}