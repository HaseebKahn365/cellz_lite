// import 'package:flutter/material.dart';
// import 'package:rive/rive.dart';

// class SubscriptionSettings extends StatefulWidget {
//   const SubscriptionSettings({Key? key}) : super(key: key);

//   @override
//   State<SubscriptionSettings> createState() => _SubscriptionSettingsState();
// }

// class _SubscriptionSettingsState extends State<SubscriptionSettings> {
//   int selectedIndex = 0; // 0 for Basic, 1 for Premium
//   bool loading = true; //the diamonds should wait for 2 seconds, to appear

//   @override
//   Widget build(BuildContext context) {
//     Future.delayed(const Duration(seconds: 2), () {
//       if (mounted) {
//         setState(() {
//           loading = false;
//         });
//       }
//     });
//     return Column(
//       children: [
//         Container(
//           color: Theme.of(context).colorScheme.surface,
//           child: Container(
//             margin: const EdgeInsets.all(12),
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(11),
//               border: Border.all(
//                 color: Theme.of(context).colorScheme.secondaryContainer,
//                 width: 1,
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: 100,
//                       child: SizedBox(
//                         width: 100,
//                         child: (loading)
//                             ? const SizedBox.shrink()
//                             : RiveAnimation.asset(
//                                 'assets/images/diamond.riv',

//                                 stateMachines: ['State Machine 1'], // Make sure the state machine name matches exactly
//                                 onInit: _onRiveInit,
//                               ),
//                       ),
//                     ),
//                     Text('Buy More Lives', style: Theme.of(context).textTheme.titleMedium),
//                     (loading)
//                         ? const SizedBox.shrink()
//                         : SizedBox(
//                             height: 100,
//                             child: SizedBox(
//                               width: 100,
//                               child: RiveAnimation.asset(
//                                 'assets/images/diamond.riv',

//                                 stateMachines: ['State Machine 1'], // Make sure the state machine name matches exactly
//                                 onInit: _onRiveInit,
//                               ),
//                             ),
//                           ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     buildPackTile(
//                       title: 'Basic Pack',
//                       lives: 50,
//                       price: 5,
//                       index: 0,
//                     ),
//                     const SizedBox(height: 10),
//                     buildPackTile(
//                       title: 'Premium Pack',
//                       lives: 250,
//                       price: 15,
//                       index: 1,
//                     ),
//                     const SizedBox(height: 10),
//                     buildPackTile(
//                       title: 'Ultimate Pack',
//                       lives: 500,
//                       price: 25,
//                       index: 2,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],

//       // Premium features
//     );
//   }

//   void _onRiveInit(Artboard artboard) {
//     final controller = StateMachineController.fromArtboard(artboard, 'State Machine 1');
//     if (controller != null) {
//       artboard.addController(controller);
//       // You can also set inputs for the state machine here if needed
//     }
//   }

//   Widget buildPackTile({
//     required String title,
//     required int lives,
//     required int price,
//     required int index,
//   }) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: selectedIndex == index ? Theme.of(context).colorScheme.primary : Colors.transparent,
//           width: 2,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: Theme.of(context).textTheme.headlineSmall,
//           ),
//           const SizedBox(height: 10),
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Theme.of(context).colorScheme.secondaryContainer),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.favorite, color: Theme.of(context).colorScheme.primary),
//                     const SizedBox(width: 5),
//                     Text(
//                       '$lives',
//                       style: Theme.of(context).textTheme.headlineMedium,
//                     ),
//                   ],
//                 ),
//               ),
//               Spacer(),
//               Text(
//                 'Get $lives extra For \$$price',
//                 style: Theme.of(context).textTheme.bodyMedium,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
