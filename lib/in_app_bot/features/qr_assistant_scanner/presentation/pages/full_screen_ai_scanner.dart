import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/chat_bubble/domain/enums/chat_mode.dart';
import 'package:in_app_bot/in_app_bot/features/chat_bubble/presentation/navigation/zoom_fade_route.dart';
import 'package:in_app_bot/in_app_bot/features/chat_bubble/presentation/widgets/chat_mode_provider.dart';
import 'package:in_app_bot/in_app_bot/features/chat_screen/presentation/pages/chat_screen.dart';
import 'package:in_app_bot/in_app_bot/features/qr_assistant_scanner/presentation/providers/qr_ai_providers.dart';
import 'package:in_app_bot/in_app_bot/features/qr_assistant_scanner/presentation/widgets/control_buttons.dart';
import 'package:in_app_bot/in_app_bot/features/qr_assistant_scanner/presentation/widgets/scanner_app_bar.dart';
import 'package:in_app_bot/in_app_bot/features/qr_assistant_scanner/presentation/widgets/scanner_info.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class FullScreenQRScanner extends ConsumerStatefulWidget {
  final String userId;

  const FullScreenQRScanner({Key? key, required this.userId}) : super(key: key);

  @override
  ConsumerState<FullScreenQRScanner> createState() =>
      _FullScreenQRScannerState();
}

class _FullScreenQRScannerState extends ConsumerState<FullScreenQRScanner>
    with WidgetsBindingObserver {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeBackButton();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeFlashButton();
    });
  }

  void _initializeFlashButton() {
    ref.read(flashButtonEnabledProvider.notifier).state = false;
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        ref.read(flashButtonEnabledProvider.notifier).state = true;
      }
    });
  }

  void _initializeBackButton() {
    Future.microtask(() {
      if (!mounted) return;
      ref.read(backButtonEnabledProvider.notifier).state = false;
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        ref.read(backButtonEnabledProvider.notifier).state = true;
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(flashStateProvider.notifier).state = false;
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      controller?.resumeCamera();
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      controller?.pauseCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFlashOn = ref.watch(flashStateProvider);
    final hasScanned = ref.watch(scannedStateProvider);
    final isBackButtonEnabled = ref.watch(backButtonEnabledProvider);
    final isFlashButtonEnabled = ref.watch(flashButtonEnabledProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _onPopInvoked();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            _buildQRView(),
            SafeArea(
              child: Column(
                children: [
                  ScannerAppBar(
                      isBackButtonEnabled: isBackButtonEnabled,
                      onBackPressed: _handleBackButton),
                  const Spacer(),
                  const ScannerInfo(),
                  const SizedBox(height: 20),
                  ControlButtons(
                    isFlashOn: isFlashOn,
                    hasScanned: hasScanned,
                    isFlashButtonEnabled: isFlashButtonEnabled,
                    onFlashPressed: _toggleFlash,
                    onFlipPressed: _flipCamera,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPopInvoked() {
    if (ref.read(backButtonEnabledProvider)) {
      _handleBackButton();
    }
  }

  Widget _buildQRView() {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.white,
        borderRadius: 20,
        borderLength: 40,
        borderWidth: 8,
        cutOutSize: MediaQuery.of(context).size.width * 0.7,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!ref.read(scannedStateProvider) && scanData.code != null) {
        _handleSuccessfulScan(scanData.code!);
      }
    });
  }

  Future<void> _handleSuccessfulScan(String scannedData) async {
    if (ref.read(scannedStateProvider)) return;

    ref.read(scannedStateProvider.notifier).state = true;

    try {
      final productDoc = await FirebaseFirestore.instance
          .collection('chatbots')
          .doc('scan_ai')
          .collection('QR')
          .doc(scannedData)
          .get();

      if (productDoc.exists) {
        final productData = productDoc.data();
        if (productData != null) {
          _handleValidProduct(scannedData, productData);
        }
      } else {
        _showErrorDialog('QR not found',
            'The scanned QR code does not correspond to any knowledge of the assistant.');
      }
    } catch (e) {
      _showErrorDialog('Error', 'There was an error retrieving the data: $e');
    }
  }

  void _handleValidProduct(
      String scannedData, Map<String, dynamic> productData) {
    ref.read(productDataProvider.notifier).state = productData;

    ref.read(chatStateProvider.notifier).setMode(
          ChatMode.productMode,
          ProductModeParams(
            appUserId: widget.userId,
            productbotId: scannedData,
            productbotName: productData['name'],
            productbotImageUrl: productData['image_url'],
            productbotDescription: productData['description'],
          ),
        );

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      ZoomFadeRoute(
        page: ChatScreen(
          appUserId: widget.userId,
          productbotId: scannedData,
          productbotName: productData['name'],
          productbotImageUrl: productData['image_url'],
          productbotDescription: productData['description'],
        ),
      ),
    );
    ref.read(scannedStateProvider.notifier).state = false;
    _stopScanning();
  }

  void _showErrorDialog(String title, String content) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(scannedStateProvider.notifier).state = false;
              },
            ),
          ],
        );
      },
    );
  }

  void _stopScanning() {
    controller?.pauseCamera();
    controller?.stopCamera();
    controller?.dispose();
    controller = null;
  }

  void _toggleFlash() {
    if (!ref.read(flashButtonEnabledProvider) ||
        ref.read(scannedStateProvider)) {
      return;
    }

    controller?.toggleFlash();
    ref.read(flashStateProvider.notifier).state = !ref.read(flashStateProvider);
  }

  void _flipCamera() async {
    if (ref.read(scannedStateProvider)) return;
    await controller?.flipCamera();
  }

  void _handleBackButton() {
    _stopScanning();
    ref.read(flashStateProvider.notifier).state = false;
    ref.read(scannedStateProvider.notifier).state = false;
    Navigator.of(context).pop();
  }
}
