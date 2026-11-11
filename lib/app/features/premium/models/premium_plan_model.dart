class PremiumPlanModel {
  final String id;
  final String title;
  final String price;
  final String period;
  final String? savingsBadge;
  final String subtitle;
  final bool isPopular;
  final bool isLifetime;

  const PremiumPlanModel({
    required this.id,
    required this.title,
    required this.price,
    required this.period,
    this.savingsBadge,
    required this.subtitle,
    this.isPopular = false,
    this.isLifetime = false,
  });

  static List<PremiumPlanModel> get defaultPlans => const [
        PremiumPlanModel(
          id: 'monthly',
          title: 'Monthly',
          price: '₦2,500',
          period: '/ month',
          subtitle: 'Billed monthly, cancel anytime',
        ),
        PremiumPlanModel(
          id: 'yearly',
          title: 'Yearly',
          price: '₦18,000',
          period: '/ year',
          savingsBadge: 'Save 40%',
          subtitle: 'Just ₦1,500/mo, billed annually',
          isPopular: true,
        ),
        PremiumPlanModel(
          id: 'lifetime',
          title: 'Lifetime',
          price: '₦35,000',
          period: 'one-time',
          savingsBadge: 'Best Value',
          subtitle: 'Pay once, enjoy full Pro access forever',
          isLifetime: true,
        ),
      ];
}

