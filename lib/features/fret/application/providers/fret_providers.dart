import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/fret_repository_impl.dart';
import '../../domain/models/demande_fret.dart';
import '../../domain/repositories/i_fret_repository.dart';
import '../services/auto_save_service.dart';
import '../services/publication_service.dart';
import '../services/totaux_calculator.dart';

final fretRepositoryProvider = Provider<IFretRepository>((ref) {
  return FretRepositoryImpl(Supabase.instance.client);
});

final totalsCalculatorProvider = Provider<TotauxCalculator>((ref) {
  return const TotauxCalculator();
});

final autoSaveServiceProvider = Provider<AutoSaveService>((ref) {
  final repository = ref.watch(fretRepositoryProvider);
  return AutoSaveService(repository: repository);
});

final publicationServiceProvider = Provider<PublicationService>((ref) {
  final repository = ref.watch(fretRepositoryProvider);
  return PublicationService(repository: repository);
});

final demandesListProvider = FutureProvider<List<DemandeFret>>((ref) async {
  final repository = ref.watch(fretRepositoryProvider);
  return repository.listDemandes();
});
