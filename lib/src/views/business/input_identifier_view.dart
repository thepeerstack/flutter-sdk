import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thepeer_flutter/src/consts/consts.dart';
import 'package:thepeer_flutter/src/core/models/the_peer_business_model.dart';
import 'package:thepeer_flutter/src/core/providers.dart';
import 'package:thepeer_flutter/src/utils/colors.dart';
import 'package:thepeer_flutter/src/widgets/peer_button.dart';
import 'package:thepeer_flutter/src/widgets/peer_header.dart';
import 'package:thepeer_flutter/src/widgets/peer_logo_icon.dart';

/// Input User Identifier Widget
class InputIdentifierView extends HookWidget {
  final ThePeerBusiness business;
  InputIdentifierView(
    this.business, {
    Key? key,
  }) : super(key: key);

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final provider = useProvider(peerControllerVM);
    final receivingUsername = useProvider(
      peerControllerVM.select(
        (v) => (v.userModel?.name ?? '').toUpperCase(),
      ),
    );

    return Form(
      key: formKey,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 38,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PeerHeader(
                  showClose: true,
                ),
                Gap(22),
                Center(
                  child: Text(
                    'Send money to',
                    style: TextStyle(
                      fontFamily: 'Gilroy-Medium',
                      package: package,
                      fontSize: 14,
                      color: peerTextColor,
                    ),
                  ),
                ),
                Gap(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PeerLogoIcon(business),
                    Gap(8),
                    Text(
                      business.name,
                      style: TextStyle(
                        fontFamily: 'Gilroy-SemiBold',
                        package: package,
                        fontSize: 24,
                        color: peerBoldTextColor,
                      ),
                    ),
                  ],
                ),
                Gap(47),
              ],
            ),
          ),
          Flexible(
              child: ListView(
            padding: EdgeInsets.all(16),
            physics: BouncingScrollPhysics(),
            children: [
              PeerTextField(
                labelText: 'Enter username',
                controller: provider.usernameTEC,
                onChanged: (username) => provider.searchUsername(
                  businessId: business.id,
                  identifier: username,
                ),
              ),
              Gap(11),
              Text(
                receivingUsername,
                style: TextStyle(
                  fontFamily: 'Gilroy-SemiBold',
                  package: package,
                  fontSize: 14,
                  color: peerBoldTextColor,
                ),
              ),
              Gap(14),
              PeerTextField(
                hintText: 'What is this for ?',
                controller: provider.reasonTEC,
                onChanged: (v) => provider.resonChange(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please input transaction remark';
                  }
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('^[a-zA-Z ]*\$')),
                ],
              ),
              Gap(56),
              PeerButton(
                title: 'Send',
                enabled: receivingUsername.isNotEmpty &&
                    provider.reasonTEC.text.isNotEmpty,
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    context.read(peerControllerVM).handleInputDetails(business);
                  }
                },
              )
            ],
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Powered by',
                style: TextStyle(
                  fontFamily: 'Gilroy-Medium',
                  package: package,
                  fontSize: 14,
                  color: peerLightTextColor,
                ),
              ),
              Gap(4),
              Image.asset(
                'assets/images/logo.png',
                package: package,
                height: 18,
              ),
            ],
          ),
          Gap(32),
        ],
      ),
    );
  }
}

class PeerTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText, hintText;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;

  const PeerTextField({
    Key? key,
    this.controller,
    this.labelText,
    this.hintText,
    this.onChanged,
    this.validator,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var hasNoValue = (controller?.text == null || controller!.text.isEmpty);
    return TextFormField(
      controller: controller,
      style: TextStyle(
        fontFamily: 'Gilroy-SemiBold',
        package: package,
        fontSize: 16,
        color: peerBoldTextColor,
      ),
      validator: validator,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: TextStyle(
          fontFamily: 'Gilroy-Medium',
          package: package,
          color: peerBlue,
        ),
        hintStyle: TextStyle(
          fontFamily: 'Gilroy-Medium',
          package: package,
          fontSize: 16,
          color: peerBoldTextColor,
        ),
        focusedBorder: outlineInputBorder.copyWith(
          borderSide: BorderSide(
            color: peerBlue,
            width: 1.4,
          ),
        ),
        filled: hasNoValue,
        fillColor: Color(0xFFFCFCFD),
        border: outlineInputBorder,
        enabledBorder: outlineInputBorder.copyWith(
          borderSide: BorderSide(
            color: peerTextFieldBorderColor,
            width: 1.4,
          ),
        ),
        errorBorder: outlineInputBorder.copyWith(
          borderSide: BorderSide(
            color: peerRed,
            width: 1.4,
          ),
        ),
      ),
    );
  }
}
