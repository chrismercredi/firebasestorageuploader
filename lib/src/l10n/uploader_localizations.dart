import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// You need to generate the localizations using:
// dart run intl_translation:extract_to_arb --output-dir=lib/uploader/l10n lib/uploader/l10n/uploader_localizations.dart
//
// Then you need to run:
//
// dart run intl_translation:generate_from_arb --output-dir=lib/uploader/l10n --no-use-deferred-loading lib/uploader/l10n/uploader_localizations.dart lib/uploader/l10n/intl_en.arb lib/uploader/l10n/intl_es.arb

import 'messages_all.dart';

class UploaderLocalizations {
  final Locale locale;

  UploaderLocalizations(this.locale);

  static Future<UploaderLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode == null || locale.countryCode!.isEmpty
            ? locale.languageCode
            : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return UploaderLocalizations(locale);
    });
  }

  static UploaderLocalizations of(BuildContext context) {
    return Localizations.of<UploaderLocalizations>(
        context, UploaderLocalizations)!;
  }

  /// extensions/int_extension.dart
  String get bytes => Intl.message(
        'Bytes',
        name: 'bytes',
        desc: 'The term for bytes in file size',
        locale: locale.toString(),
      );

  /// extensions/int_extension.dart
  String get kilobytes => Intl.message(
        'KB',
        name: 'kilobytes',
        desc: 'The term for kilobytes in file size',
        locale: locale.toString(),
      );

  /// extensions/int_extension.dart
  String get megabytes => Intl.message(
        'MB',
        name: 'megabytes',
        desc: 'The term for megabytes in file size',
        locale: locale.toString(),
      );

  /// extensions/int_extension.dart
  String get gigabytes => Intl.message(
        'GB',
        name: 'gigabytes',
        desc: 'The term for gigabytes in file size',
        locale: locale.toString(),
      );

  /// extensions/int_extension.dart
  String get terabytes => Intl.message(
        'TB',
        name: 'terabytes',
        desc: 'The term for terabytes in file size',
        locale: locale.toString(),
      );

  /// widgets/select_file_list_tile.dart
  String get calculatingFileSize => Intl.message(
        'Calculating...',
        name: 'calculatingFileSize',
        desc: 'Text displayed while calculating file size',
        locale: locale.toString(),
      );

  /// widgets/select_file_list_tile.dart
  String get filePathLabel => Intl.message(
        'Path',
        name: 'filePathLabel',
        desc: 'Label for displaying file path',
        locale: locale.toString(),
      );

  /// widgets/select_file_list_tile.dart
  String get fileTypeLabel => Intl.message(
        'Type',
        name: 'fileTypeLabel',
        desc: 'Label for displaying file type',
        locale: locale.toString(),
      );

  /// widgets/select_file_list_tile.dart
  String get fileSizeLabel => Intl.message(
        'Size',
        name: 'fileSizeLabel',
        desc: 'Label for displaying file size',
        locale: locale.toString(),
      );

  /// widgets/select_files_button.dart
  String get selectFilesButtonLabel => Intl.message(
        'Select Files',
        name: 'selectFilesButtonLabel',
        desc: 'Label for the button that opens the file picker',
        locale: locale.toString(),
      );

  /// widgets/select_files_state_widget.dart
  String get noFilesSelectedTitle => Intl.message(
        'No files selected yet',
        name: 'noFilesSelectedTitle',
        desc: 'Title text for the state where no files have been selected',
        locale: locale.toString(),
      );

  /// widgets/select_files_state_widget.dart
  String get pickFilesToStartSubtitle => Intl.message(
        'Pick some files to get started',
        name: 'pickFilesToStartSubtitle',
        desc: 'Subtitle text encouraging the user to pick files',
        locale: locale.toString(),
      );

  /// widgets/select_more_files_button.dart
  String get selectMoreFilesButtonLabel => Intl.message(
        'Select More Files',
        name: 'selectMoreFilesButtonLabel',
        desc: 'Label for the button that allows selecting more files',
        locale: locale.toString(),
      );

  /// widgets/upload_files_button.dart
  String get uploadFilesButtonLabel => Intl.message(
        'Upload Files',
        name: 'uploadFilesButtonLabel',
        desc: 'Label for the button that initiates file upload',
        locale: locale.toString(),
      );

  /// widgets/upload_task_list_tile.dart
  String get uploadingFile => Intl.message(
        'Uploading',
        name: 'uploadingFile',
        desc: 'Prefix text for displaying the file being uploaded',
        locale: locale.toString(),
      );

  /// widgets/upload_task_list_tile.dart
  String get uploadError => Intl.message(
        'Something went wrong!',
        name: 'uploadError',
        desc: 'Text displayed when an error occurs during file upload',
        locale: locale.toString(),
      );

  /// widgets/upload_task_list_tile.dart
  String get uploadComplete => Intl.message(
        'Upload complete!',
        name: 'uploadComplete',
        desc: 'Text displayed when file upload is complete',
        locale: locale.toString(),
      );

  /// widgets/upload_task_list_tile.dart
  String get waitingToUpload => Intl.message(
        'Waiting to start upload...',
        name: 'waitingToUpload',
        desc: 'Text displayed while waiting to start file upload',
        locale: locale.toString(),
      );

  /// widgets/upload_task_list_tile.dart
  String get uploading => Intl.message(
        'Uploading',
        name: 'uploading',
        desc: 'Text displayed during file upload',
        locale: locale.toString(),
      );

  /// uploader_widget.dart
  String get userNotAuthenticated => Intl.message(
        'User not authenticated',
        name: 'userNotAuthenticated',
        desc:
            'Message displayed when the user is not authenticated in UploaderWidget',
        locale: locale.toString(),
      );

  /// uploader_view.dart
  String get fileUploaderTitle => Intl.message(
        'File uploader',
        name: 'fileUploaderTitle',
        desc: 'Title for the file uploader in UploaderView',
        locale: locale.toString(),
      );

  /// uploader_view.dart
  String get supportedFileTypes => Intl.message(
        'Supported file types: png, jpg, pdf, docx, xlsx',
        name: 'supportedFileTypes',
        desc: 'Subtitle text listing supported file types in UploaderView',
        locale: locale.toString(),
      );
}

class UploaderLocalizationsDelegate
    extends LocalizationsDelegate<UploaderLocalizations> {
  const UploaderLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  Future<UploaderLocalizations> load(Locale locale) =>
      UploaderLocalizations.load(locale);

  @override
  bool shouldReload(UploaderLocalizationsDelegate old) => false;
}
