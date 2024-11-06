import 'package:flutter/material.dart';

class Page5 extends StatelessWidget {
  // Liste de joueurs fictifs
  final List<Map<String, dynamic>> fakePlayers = List.generate(47, (index) {
    return {
      'position': index + 4, // Position du joueur (à partir de 4)
      'name': 'Player ${index + 4}', // Nom du joueur fictif
      'score': (1500 - index * 30).toString(), // Score fictif décroissant
    };
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7F3DFF),
        title: Text("Leaderboard"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        color: Color(0xFFEDEAFF),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Boutons de sélection (Hebdomadaire / Tous les temps)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleButton("Weekly"),
                ToggleButton("All Time"),
              ],
            ),
            SizedBox(height: 16),
            // Box pour le rang personnel
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Color(0xFFFFE3E3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "#4 You are doing better than 60% of other players!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            // Podium pour les trois premiers scores
            Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // 2nd Place
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.grey,
                          child: Text("A", style: TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: 50,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              "2",
                              style: TextStyle(fontSize: 24, color: Colors.white),
                            ),
                          ),
                        ),
                        Text("Alena Donin", style: TextStyle(fontWeight: FontWeight.w500)),
                        Text("1,469 QP", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    // 1st Place
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Color(0xFFFFD700),
                          child: Text("D", style: TextStyle(color: Colors.white, fontSize: 24)),
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: 60,
                          height: 130,
                          decoration: BoxDecoration(
                            color: Color(0xFFFFD700),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              "1",
                              style: TextStyle(fontSize: 28, color: Colors.white),
                            ),
                          ),
                        ),
                        Text("Davis Curtis", style: TextStyle(fontWeight: FontWeight.w500)),
                        Text("2,560 QP", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    // 3rd Place
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.brown,
                          child: Text("C", style: TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: 50,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.brown,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              "3",
                              style: TextStyle(fontSize: 24, color: Colors.white),
                            ),
                          ),
                        ),
                        Text("Craig Gouse", style: TextStyle(fontWeight: FontWeight.w500)),
                        Text("1,063 QP", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24),
            // Liste des autres joueurs
            Expanded(
              child: ListView.builder(
                itemCount: fakePlayers.length,
                itemBuilder: (context, index) {
                  final player = fakePlayers[index];
                  return PlayerListTile(
                    position: player['position'],
                    name: player['name'],
                    score: player['score'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ToggleButton extends StatelessWidget {
  final String text;

  ToggleButton(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: () {},
        child: Text(
          text,
          style: TextStyle(color: Color(0xFF7F3DFF)),
        ),
      ),
    );
  }
}

class PlayerListTile extends StatelessWidget {
  final int position;
  final String name;
  final String score;

  PlayerListTile({
    required this.position,
    required this.name,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.purple[100],
          child: Text(name[0]),
        ),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(score + " points"),
        trailing: Text("#" + position.toString(), style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}
