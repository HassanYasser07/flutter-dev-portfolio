import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/pdf_download_helper.dart';
import '../../data/cv_constants.dart';
import 'cv_state.dart';

class CvCubit extends Cubit<CvState> {
  CvCubit() : super(const CvState());

  /// Triggers PDF download for the user's CV.
  void downloadCv() {
    try {
      PdfDownloadHelper.downloadPdf(
        CvConstants.cvAssetPath,
        CvConstants.cvDownloadName,
      );
      emit(state.copyWith(
        status: CvStatus.success,
        message: 'Download initiated',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CvStatus.error,
        message: e.toString(),
      ));
    }
  }

  /// Opens the PDF CV document in a new browser window/tab.
  void openCvInNewTab() {
    try {
      PdfDownloadHelper.openInNewTab(
        CvConstants.cvAssetPath,
      );
      emit(state.copyWith(
        status: CvStatus.success,
        message: 'Opened in new tab',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CvStatus.error,
        message: e.toString(),
      ));
    }
  }
}
