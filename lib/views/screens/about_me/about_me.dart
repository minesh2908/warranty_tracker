import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:track_my_things/constants/urls.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMe extends StatefulWidget {
  const AboutMe({super.key});

  @override
  State<AboutMe> createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  @override
  Widget build(BuildContext context) {
    final appLocaltization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: const BackButton(),
        elevation: 2,
        title: Text(
          AppLocalizations.of(context)!.aboutUs,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.black87,
                    radius: 100,
                    child: CircleAvatar(
                      radius: 97,
                      //backgroundColor: Colors.white,
                      backgroundImage:
                          AssetImage('assets/images/profilephoto.jpg'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    appLocaltization.mineshSarawogi,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.scrim,
                    ),
                  ),
                ),
                Text(
                  appLocaltization.flutterDeveloper,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.scrim,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: InkWell(
                          onTap: () {
                            launchUrl(github);
                          },
                          child: Image.asset(
                            'assets/images/giticon.png',
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: InkWell(
                          onTap: () {
                            launchUrl(linkedin);
                          },
                          child: Image.asset(
                            'assets/images/linkedIicon.png',
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: InkWell(
                          onTap: () {
                            launchUrl(portfolio);
                          },
                          child: Image.asset(
                            'assets/images/portfolioIcon.png',
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                  child: Center(
                    child: Text(
                      appLocaltization.aboutMeText,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.scrim,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          thickness: 3,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          appLocaltization.thankYou,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.scrim,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          thickness: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
             Text('Made with 💙 in India',style:TextStyle(color: Theme.of(context).colorScheme.scrim)),
          ],
        ),
      ),
    );
  }
}
