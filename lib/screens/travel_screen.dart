import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travelgo/providers/travel_form.dart';
import 'package:travelgo/services/services.dart';
import 'package:travelgo/widgets/widgets.dart';
import 'package:travelgo/ui/input_decorations.dart';
import 'package:provider/provider.dart';

import '../services/travels_service.dart';

class TravelScreen extends StatelessWidget {
  const TravelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final travelService = Provider.of<TravelsService>(context);
    return ChangeNotifierProvider(
      create: (_) => TravelForm(travelService.selectedtravel),
      child: _TravelScreenBody(travelService: travelService),
    );
  }
}

class _TravelScreenBody extends StatelessWidget {
  const _TravelScreenBody({
    //super.key,
    required this.travelService,
  });

  final TravelsService travelService;

  @override
  Widget build(BuildContext context) {
    final travelForm = Provider.of<TravelForm>(context);
    return Scaffold(
      body: SingleChildScrollView(        
        child: Column(
          children: [
            Stack(
              children: [
                TravelImage(url: travelService.selectedtravel.localUrl),
                Positioned(
                  top: 50,
                  left: 20,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 20,
                  child: IconButton(
                    onPressed: () async {                      
                      final picker = ImagePicker();
                      final XFile? pickedFile = await picker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 100,
                        maxWidth: 1500,
                        maxHeight: 2000,
                      );
                      if (pickedFile == null) {                        
                        return;
                      }
                      
                      travelService
                          .updateSelectedTravelImage(pickedFile.path);
                    },
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
            const _TravelForm(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: travelService.isSaving
            ? null
            : () async {
                FocusScope.of(context).unfocus();                
                if (!travelForm.isValidForm()) return;
                
                final String? imageUrl = await travelService.uploadImage();
               
                if (imageUrl != null) travelForm.travel.localUrl = imageUrl;
                await travelService.saveOrCreateTravel(travelForm.travel);
              },
        child: travelService.isSaving
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.save_outlined),
      ),
    );
  }
}

class _TravelForm extends StatelessWidget {
  const _TravelForm();

  @override
  Widget build(BuildContext context) {
    final travelForm = Provider.of<TravelForm>(context);
    final travel = travelForm.travel;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: travelForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              const SizedBox(height: 15),
              TextFormField(
                initialValue: travel.titulo,
                onChanged: (value) => travel.titulo = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Título obrigatório';
                  }
                  return null;
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Título da viagem',
                  labelText: 'Título:',
                ),
              ),              
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 5),
            blurRadius: 5,
          )
        ],
      );
}
