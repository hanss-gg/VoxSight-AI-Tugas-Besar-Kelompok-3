import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CameraMain extends StatefulWidget {
  const CameraMain({super.key});

  @override
  State<CameraMain> createState() => _CameraMainState();
}

class _CameraMainState extends State<CameraMain> {

  WebSocketChannel? _channel;
  bool _isConnected = false;

  void startStream() {
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://voxsight-demo.ngonsul.web.id/watch/PERVOX-0001-22526'),
    );

    setState(() {
      _isConnected = true;
    });
  }

  void stopStream() {
    _channel?.sink.close();

    setState(() {
      _channel = null;
      _isConnected = false;
    });
  }

  @override
  void initState() {
    super.initState();
    startStream();
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF223148),
        title: Text(
          "Camer Tracking",
          style: const TextStyle(color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),

            Text(
              'Tracking GPS dan Tracking Camera',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF223148),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Center(
                child: Text(
                  'latitude: xxx Longitude: xxx',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF223148),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: _channel == null
                  ? const Center(
                      child: Text(
                        'Stream berhenti',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : StreamBuilder<String>(
                      stream: _channel!.stream.cast<String>(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Center(
                            child: Text(
                              snapshot.data!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error: ${snapshot.error}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          );
                        }
                      },
                    ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isConnected ? null : startStream,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF223148),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Start Stream', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isConnected ? stopStream : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Stop Stream'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}