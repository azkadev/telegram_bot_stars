import 'dart:io';

import 'package:server_universe/native/native.dart';
import 'package:telegram_client/telegram_client/telegram_client_core.dart';

void main() async {
  print("start");
  int port = int.tryParse(Platform.environment["PORT"] ?? "3000") ?? 3000;
  String host = Platform.environment["HOST"] ?? "0.0.0.0";

  TelegramClient tg = TelegramClient();
  tg.ensureInitialized(
    is_init_tdlib: false,
  );

  ServerUniverseNative app = ServerUniverseNative(
    onNotFound: (req, res) async {
      return res.json({
        "@type": "error",
        "message": "path_not_found",
        "description": "PATH: Not Found"
      });
    },
    onError: (req, res, e, stack) {
      return res.json({"@type": "error", "message": "server_crash"});
    },
  );
  app.all("/", (req, res) {
    return res.send("oke");
  });
  app.all("/telegram/webhook", (req, res) {
    req.body;
    return res.send("oke");
  });

  await app.listen(port: port, bindIp: host);

  print("Server on");
}
