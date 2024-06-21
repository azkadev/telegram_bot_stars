/* <!-- START LICENSE -->


Program Ini Di buat Oleh DEVELOPER Dari PERUSAHAAN GLOBAL CORPORATION 
Social Media: 

- Youtube: https://youtube.com/@Global_Corporation 
- Github: https://github.com/globalcorporation
- TELEGRAM: https://t.me/GLOBAL_CORP_ORG_BOT

Seluruh kode disini di buat 100% murni tanpa jiplak / mencuri kode lain jika ada akan ada link komment di baris code

Jika anda mau mengedit pastikan kredit ini tidak di hapus / di ganti!

Jika Program ini milik anda dari hasil beli jasa developer di (Global Corporation / apapun itu dari turunan itu jika ada kesalahan / bug / ingin update segera lapor ke sub)

Misal anda beli Beli source code di Slebew CORPORATION anda lapor dahulu di slebew jangan lapor di GLOBAL CORPORATION!

Jika ada kendala program ini (Pastikan sebelum deal project tidak ada negosiasi harga)
Karena jika ada negosiasi harga kemungkinan

1. Software Ada yang di kurangin
2. Informasi tidak lengkap
3. Bantuan Tidak Bisa remote / full time (Ada jeda)

Sebelum program ini sampai ke pembeli developer kami sudah melakukan testing

jadi sebelum nego kami sudah melakukan berbagai konsekuensi jika nego tidak sesuai ? 
Bukan maksud kami menipu itu karena harga yang sudah di kalkulasi + bantuan tiba tiba di potong akhirnya bantuan / software kadang tidak lengkap


<!-- END LICENSE --> */
// ignore_for_file: unnecessary_brace_in_string_interps, non_constant_identifier_names, empty_catches, unused_catch_stack

import 'dart:io';

import 'package:telegram_bot_stars/telegram_bot_stars.dart';
import 'package:telegram_bot_stars/logger/logger.dart';

import 'package:general_lib/general_lib.dart';

import 'package:path/path.dart';
import 'package:telegram_client/tdlib/scheme/tdlib_option_parameter.dart';
import 'package:telegram_client/telegram_client.dart';

void main(List<String> arguments) async {
  logger.info("Telegram Bot Stars By Azkadev");

  Directory database_telegram = Directory(join(Directory.current.path, "database_telegram"));
  if (!database_telegram.existsSync()) {
    await database_telegram.create(recursive: true);
  }
  

  Directory database_user = await Future(() async {
    List<Directory> dirs = Directory(join(database_telegram.path))
        .listSync()
        .where((element) {
          if (element is Directory && RegExp(r"^(client_(.*))$", caseSensitive: false).hasMatch(basename(element.path))) {
            return true;
          }
          return false;
        })
        .map((e) => (e as Directory))
        .toList();

    // while (true) {
    // await Future.delayed(Duration(milliseconds: 100));
    Directory directory_choose = logger.chooseOne(
      "Silahkan Pilih Client / Buat Baru",
      choices: [
        Directory(join(database_telegram.path, "create_new_client")),
        ...dirs,
      ],
      display: (choice) {
        return basename(choice.path).replaceAll(RegExp(r"^(client_)", caseSensitive: false), "");
      },
    );
    if (basename(directory_choose.path) == "create_new_client") {
      while (true) {
        String new_client_name = logger.prompt("❔️ New Client Name: ").trim();
        if (new_client_name.isEmpty) {
          logger.err("Tolong isi data dengan benar!");
          continue;
        }
        Directory directory_new_client = Directory(join(database_telegram.path, "client_${new_client_name}"));
        if (directory_new_client.existsSync()) {
          logger.err("Client: ${new_client_name} Sudah Ada");
          continue;
        }
        logger.success("Succes Create Client: ${new_client_name}");
        return directory_new_client;
      }
    }
    return directory_choose;
    // }
  });
  TelegramClient tg = TelegramClient();

  tg.ensureInitialized(
    telegramClientTdlibOption: TelegramClientTdlibOption(
      clientOption: TdlibOptionParameter({
        'database_directory': database_user.path,
        'files_directory': database_user.path,
        "use_test_dc": false,
      }),
      invokeTimeOut: Duration(minutes: 1),
      delayInvoke: Duration(milliseconds: 10),
      delayUpdate: Duration.zero,
      timeOutUpdate: 1.0,
    ),
  );

  tg.on(
    event_name: tg.event_update,
    onUpdate: (updateTelegramClient) async {
      try {
        await tg.autoSetData(updateTelegramClient);

        Map? update = await updateTelegramClient.updateRaw(
          is_lite: false,
          updataOptionTelegramClient: UpdataOptionTelegramClient(
            updataMessageTelegramClient: UpdataMessageTelegramClient(
              bot_is_skip_old_message: false,
              user_is_skip_old_message: true,
              skipOldChatTypes: [
                "private",
                "group",
                "channel",
                "supergroup",
              ],
            ),
          ),
        );

        if (update == null) {
          return null;
        }

        if (update["@type"] == "updateAuthorizationState") {
          if (update["authorization_state"] is Map) {
            var authStateType = update["authorization_state"]["@type"];

            if (authStateType == "authorizationStateWaitRegistration") {
              if (update["authorization_state"]["terms_of_service"] is Map) {
                Map terms_of_service = update["authorization_state"]["terms_of_service"] as Map;
                if (terms_of_service["text"] is Map) {
                  await tg.tdlib.invoke(
                    "registerUser",
                    parameters: {
                      "first_name": "random name",
                      "last_name": "generalfoss ${DateTime.now().toString()}",
                    },
                    clientId: updateTelegramClient.telegramClientData.tdlib_client_id,
                  );
                }
              }
            }

            if (authStateType == "authorizationStateClosed") {
              logger.info("silahkan login lagi");
              exit(1);
            }

            if (authStateType == "authorizationStateLoggingOut") {}

            if (authStateType == "authorizationStateClosed") {
              print("close: ${updateTelegramClient.telegramClientData.tdlib_client_id}");
              await tg.tdlib.exitClientById(updateTelegramClient.telegramClientData.tdlib_client_id, isClose: false);
            }

            if (authStateType == "authorizationStateWaitPhoneNumber") {
              while (true) {
                await Future.delayed(Duration(milliseconds: 10));
                String phone_number_or_token_bot_procces = logger.prompt("❔️ Nomor Ponsel / Token Bot @botfather", defaultValue: "+628888888888 / 123456789:abcdfghijklmnopqrstuvwxyz ", hidden: false).trim().replaceAll(
                      RegExp(r"( |\+)", caseSensitive: false),
                      "",
                    );
                if (phone_number_or_token_bot_procces.isEmpty) {
                  logger.err("Tolong isi data dengan benar!");
                  continue;
                }
                logger.info("Request Code: ${phone_number_or_token_bot_procces}");
                var res = {};

                if (RegExp(r"^(([0-9]+):AA(.*))$", caseSensitive: false).hasMatch(phone_number_or_token_bot_procces)) {
                  res = await tg.invoke(
                    // method: "setAuthenticationPhoneNumber",
                    parameters: {
                      "@type": "checkAuthenticationBotToken",
                      "token": phone_number_or_token_bot_procces,
                    },
                    telegramClientData: updateTelegramClient.telegramClientData,
                  );
                } else {
                  res = await tg.invoke(
                    // method: "setAuthenticationPhoneNumber",
                    parameters: {
                      "@type": "setAuthenticationPhoneNumber",
                      "phone_number": phone_number_or_token_bot_procces,
                    },
                    telegramClientData: updateTelegramClient.telegramClientData,
                  );
                }
                if (res["@type"] == "error") {
                  logger.err(jsonToMessage(res, jsonFullMedia: {}));
                  continue;
                }
                return;
                // break;
              }
            }

            if (authStateType == "authorizationStateWaitCode") {
              while (true) {
                await Future.delayed(Duration(milliseconds: 10));
                String code_procces = logger.prompt("❔️ Code", defaultValue: "12345 ", hidden: false).trim().replaceAll(RegExp(r"( |\+)", caseSensitive: false), "");
                if (code_procces.isEmpty) {
                  logger.err("Tolong isi data dengan benar!");
                  continue;
                }
                logger.info("send Code: ${code_procces}");
                var res = await tg.invoke(
                  // method: "setAuthenticationPhoneNumber",
                  parameters: {
                    "@type": "checkAuthenticationCode",
                    "code": code_procces,
                  },
                  telegramClientData: updateTelegramClient.telegramClientData,
                );

                if (res["@type"] == "error") {
                  logger.err(jsonToMessage(res, jsonFullMedia: {}));
                  continue;
                }
                return;
                // break;
              }
            }

            if (authStateType == "setAuthenticationEmailAddress") {}

            if (authStateType == "authorizationStateWaitEmailCode") {}

            if (authStateType == "authorizationStateWaitPassword") {}
            if (authStateType == "authorizationStateWaitOtherDeviceConfirmation") {}
            if (authStateType == "authorizationStateReady") {
              var getMe = await tg.tdlib.getMe(clientId: updateTelegramClient.telegramClientData.tdlib_client_id);

              logger.success(jsonToMessage(getMe["result"], jsonFullMedia: {}));
              return;
            }
          }

          update.printPretty();

          return;
        }

        if (update["message"] is Map) {
          Map msg = update["message"];
          // msg.clone().printPretty();
          await updateMessage(
            msg: msg,
            tg: tg,
            updateTelegramClient: updateTelegramClient,
          );
        }
      } catch (e, stack) {
        logger.err("${e} ${stack}");
      }
    },
    onError: (error, stackTrace) {
      logger.err("${error} ${stackTrace}");
    },
  );

  Map init_res = await tg.tdlib.createclient(clientId: tg.tdlib.td_create_client_id());
  if (init_res["@type"] == "error") {
    init_res.printPretty();

    exit(1);
  }
}
