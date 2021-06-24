import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thepeer_flutter/src/consts/consts.dart';
import 'package:thepeer_flutter/src/core/models/the_peer_business_model.dart';
import 'package:thepeer_flutter/src/core/models/the_peer_user_ref_model.dart';
import 'package:thepeer_flutter/src/core/providers.dart';
import 'package:thepeer_flutter/src/utils/colors.dart';
import 'package:thepeer_flutter/src/utils/extensions.dart';
import 'package:thepeer_flutter/src/widgets/peer_button.dart';
import 'package:thepeer_flutter/src/widgets/peer_header.dart';
import 'package:thepeer_flutter/src/widgets/peer_loader_widget.dart';
import 'package:thepeer_flutter/src/widgets/peer_logo_icon.dart';

/// Input User Identifier Widget
class InputIdentifierView extends StatefulHookWidget {
  final ThePeerBusiness business;
  InputIdentifierView(
    this.business, {
    Key? key,
  }) : super(key: key);

  @override
  _InputIdentifierViewState createState() => _InputIdentifierViewState();
}

class _InputIdentifierViewState extends State<InputIdentifierView> {
  final formKey = GlobalKey<FormState>();

  /// Focus nodes
  final focus1 = FocusNode();
  final focus2 = FocusNode();

  @override
  void initState() {
    super.initState();

    /// Start focus listeners
    focus1.addListener(() => setState(() {}));
    focus2.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final provider = useProvider(peerControllerVM);

    final receivingUsername = useProvider(
      peerControllerVM.select(
        (v) => (v.userModel?.name ?? '').toUpperCase(),
      ),
    );

    final receivingIdentifierEmpty = useProvider(
      peerControllerVM.select(
        (v) => v.userModel == ThePeerUserRefModel.empty(),
      ),
    );

    final userModel = useProvider(
      peerControllerVM.select(
        (v) {
          return v.userModel;
        },
      ),
    );

    return Form(
      key: formKey,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 38,
            ),
            child: PeerHeader(
              showClose: true,
            ),
          ),
          Flexible(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          PeerLogoIcon(widget.business),
                          Gap(8),
                          Text(
                            widget.business.name,
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
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PeerTextField(
                        labelText: 'Enter ${widget.business.identifier_type}',
                        controller: provider.identifierTEC,
                        hintText: widget.business.hintText,
                        isError: receivingIdentifierEmpty,
                        focusNode: focus1,
                        errorText: receivingIdentifierEmpty ? '' : null,
                        onChanged: (username) => provider.searchIdentifier(
                          businessId: widget.business.id,
                          identifier: username,
                          identifier_type: widget.business.identifierType,
                        ),
                      ),
                      AnimatedPadding(
                        duration: Duration(
                          milliseconds: 250,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical:
                              (receivingIdentifierEmpty || userModel == null) &&
                                      provider.isLoading == false
                                  ? 0
                                  : 12,
                        ),
                        child: provider.isLoading
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PeerLoaderWidget(
                                    height: 14,
                                    strokeWidth: 2,
                                  ),
                                ],
                              )
                            : Text(
                                receivingIdentifierEmpty == true
                                    ? "Cannot resolve user's details"
                                    : receivingUsername,
                                style: TextStyle(
                                  fontFamily: 'Gilroy-SemiBold',
                                  package: package,
                                  fontSize: 14,
                                  color: receivingIdentifierEmpty
                                      ? peerRed
                                      : peerBoldTextColor,
                                ),
                              ),
                      ),
                      if (provider.isLoading == false &&
                          receivingIdentifierEmpty == true)
                        Gap(18),
                      PeerTextField(
                        labelText: 'What is this for ?',
                        controller: provider.reasonTEC,
                        focusNode: focus2,
                        onChanged: (v) => provider.resonChange(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please input transaction remark';
                          }
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp('^[a-zA-Z ]*\$'),
                          ),
                        ],
                      ),
                      Gap(56),
                      PeerButton(
                        title: 'Send',
                        enabled: receivingUsername.isNotEmpty &&
                            provider.reasonTEC.text.isNotEmpty,
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            context
                                .read(peerControllerVM)
                                .handleInputDetails(widget.business);
                          }
                        },
                      )
                    ],
                  ),
                ),
                Gap(context.screenHeight(.3)),
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
          ),
        ],
      ),
    );
  }
}

class PeerTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText, hintText, errorText;
  final bool isError;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;

  const PeerTextField({
    Key? key,
    this.isError = false,
    this.controller,
    this.labelText,
    this.errorText,
    this.hintText,
    this.onChanged,
    this.focusNode,
    this.validator,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasNoValue = (controller?.text == null || controller!.text.isEmpty);
    final hasFocus = focusNode?.hasFocus ?? false;
    return TextFormField(
      controller: controller,
      style: TextStyle(
        fontFamily: 'Gilroy-SemiBold',
        package: package,
        fontSize: 16,
        color: peerBoldTextColor,
      ),
      focusNode: focusNode,
      validator: validator,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        errorText: errorText,
        labelStyle: TextStyle(
          fontFamily: 'Gilroy-Medium',
          package: package,
          color: isError
              ? peerRed
              : hasFocus
                  ? peerBlue
                  : peerBoldTextColor,
        ),
        errorStyle: TextStyle(
          fontFamily: 'Gilroy-Medium',
          package: package,
          color: peerRed,
        ),
        hintStyle: TextStyle(
          fontFamily: 'Gilroy-Medium',
          package: package,
          fontSize: 15,
          color: peerBoldTextColor.withOpacity(.8),
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
