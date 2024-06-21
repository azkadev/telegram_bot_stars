import 'package:server_universe/edge/edge.dart';
import 'package:server_universe/edge_http/server_universe_http_client.dart';
import 'package:telegram_bot_stars/config/config.dart';
import 'package:telegram_client/telegram_client.dart';

void main() async {
  print("start");
  ServerUniverseEdge app = ServerUniverseEdge(
    onNotFound: (req, res) async {
      return res.status(404).json({"@type": "error", "message": "path_not_found", "description": "PATH: ${req.path} Not Found"});
    },
    onError: (req, res, object, stackTrace) {
      return res.status(500).json({"@type": "error", "message": "server_crash"});
    },
  );
  app.ensureInitialized();
  TelegramClient tg = TelegramClient();
  tg.ensureInitialized(
    is_init_tdlib: false,
    telegramClientTelegramBotApiOption: TelegramClientTelegramBotApiOption(
      tokenBot: TelegramBotStarsConfig.telegram_token_bot,
      clientOption: {},
      httpClient: ServerUniverseHttpClient(),
    ),
  );
  app.all("/", (req, res) {
    return res.send("oke");
  });
  app.all("/version", (req, res) {
    return res.json({
      "@type": "version",
      "version": "0.0.0",
    });
  });
}
