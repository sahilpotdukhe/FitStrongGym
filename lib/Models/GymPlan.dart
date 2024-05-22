class GymPlan {
  final String id;
  final String name;
  final int months;
  final double fee;
  final bool personalTraining;

  GymPlan({
    required this.id,
    required this.name,
    required this.months,
    required this.fee,
    required this.personalTraining,
  });
  // Add this method
  static GymPlan? findById(List<GymPlan> plans, String id) {
    try {
      return plans.firstWhere((plan) => plan.id == id);
    } catch (e) {
      return null;
    }
  }
}
