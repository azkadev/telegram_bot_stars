// ignore_for_file: unused_local_variable

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
// ignore_for_file: non_constant_identifier_names,

import 'dart:async';
import 'dart:math';

import 'package:telegram_client/telegram_client/telegram_client.dart';

FutureOr<dynamic> updateMessage({
  required Map msg,
  required TelegramClient tg,
  required UpdateTelegramClient updateTelegramClient,
}) async {
  String caption = "";
  if (msg["caption"] is String) {
    caption = msg["caption"];
  }
  String text = "";
  if (msg["text"] is String) {
    text = msg["text"];
  }
  String caption_msg = "${text.trim()} ${caption.trim()}".trim();
  bool isOutgoing = false;
  if (msg["is_outgoing"] is bool) {
    isOutgoing = msg["is_outgoing"];
  }
  if (msg["chat"] is Map == false) {
    return null;
  }
  bool isAdmin = false;

  String chat_type = (msg["chat"]["type"] as String).replaceAll(RegExp(r"(super)", caseSensitive: false), "");
  if (chat_type.isEmpty) {
    return null;
  }
  if (isOutgoing) {
    isAdmin = true;
  } else {
    if (updateTelegramClient.telegramClientData.is_bot) {
      isAdmin = true;
    }
  }

  Map msg_from = msg["from"];
  Map msg_chat = msg["chat"];

  int msg_id = (msg["id"] is int) ? (msg["id"] as int) : 0;
  int from_id = msg["from"]["id"];
  int chat_id = msg["chat"]["id"];

  if (msg["chat"]["type"] is String == false) {
    msg["chat"]["type"] = "";
  }
  if (isAdmin == false) {
    return;
  }
  if (RegExp(r"^((/)?me)", caseSensitive: false).hasMatch(caption_msg)) {
    return await tg.request(
      parameters: {
        "@type": "sendMessage",
        "chat_id": chat_id,
        "text": "Hai: ${updateTelegramClient.telegramClientData.is_bot}",
      },
      telegramClientData: updateTelegramClient.telegramClientData,
    );
  }
  if (RegExp(r"^((/)?start)", caseSensitive: false).hasMatch(caption_msg)) {
    return await tg.request(
      parameters: {
        "@type": "sendMessage",
        "chat_id": chat_id,
        "text": "hi i am a robot, created by azka dev",
        "reply_markup": {
          "inline_keyboard": [
            [
              {
                "text": "AZKADEV",
                "url": "https://github.com/azkadev",
              }
            ]
          ]
        }
      },
      telegramClientData: updateTelegramClient.telegramClientData,
    );
  }

  RegExp regExp_echo = RegExp(r"^((/)?(create_invoice[ ]+)(.*))", caseSensitive: false);
  if (regExp_echo.hasMatch(caption_msg)) {
    String invoice_amount_raw = caption_msg.replaceAll(RegExp(r"^((/)?(create_invoice[ ]+))", caseSensitive: false), "");
    int amount = (num.tryParse(invoice_amount_raw) ?? 0).toInt();
    if (amount < 1) {
      amount = Random().nextInt(100) + 1;
    }
    Map res = await tg.request(
      parameters: {
        "@type": "createInvoiceLink",
        "title": "Invoice ${DateTime.now().toString()}",
        "description": "${msg_from["first_name"]}",
        "payload": "${DateTime.now().millisecondsSinceEpoch} ${msg_from["id"]}",
        "currency": "XTR",
        "prices": [
          {
            "label": "itemone",
            "amount": amount,
          }
        ]
      },
      telegramClientData: updateTelegramClient.telegramClientData,
    );
    return await tg.request(
      parameters: {
        "@type": "sendMessage",
        "chat_id": chat_id,
        "text": "Please Tap Inline Button Below",
        "reply_markup": {
          "inline_keyboard": [
            [
              {
                "text": "Pay",
                "url": res["result"],
              }
            ]
          ]
        }
      },
      telegramClientData: updateTelegramClient.telegramClientData,
    );
  }
}
