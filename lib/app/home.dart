import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:piano/piano.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String? choice;
  // int? isSelected;
  FlutterMidi flutterMidi = FlutterMidi();

  // String item1 = 'Piano';
  // String item2 = 'Guitar';
  // String item2 = 'Strings';
  // String item3 = 'Flute';

  @override
  void initState() {
    load('assets/sf2/Yamaha.sf2');
    super.initState();
  }

  void load(String asset) async {
    flutterMidi.unmute(); // Optionally Unmute
    ByteData byte = await rootBundle.load(asset);
    flutterMidi.prepare(sf2: byte, name: 'assets/sf2/$choice.sf2'.replaceAll('assets/sf2/', ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        centerTitle: true,
        leading: TextButton(
          onPressed: () {},
          child: const Icon(
            Icons.queue_music_outlined,
            color: Colors.white,
            size: 28,
          ),
        ),
        title: const Text(
          'Multi Instruments',
          style: TextStyle(
            fontSize: 22,
            // color: Colors.white,
          ),
        ),
        actions: [
          DropdownButton<String?>(
            value: choice ?? 'Guitars',
            //hint: const Text('Music', style: TextStyle(color: Colors.white),),
            dropdownColor: Colors.black87,
            iconEnabledColor: Colors.white,
            padding: const EdgeInsets.only(right: 8),
            items: const [
              DropdownMenuItem(
                value: 'Guitars',
                child: Text('Guitars', style: TextStyle(color: Colors.white),),
              ),
              DropdownMenuItem(
                value: 'Strings',
                child: Text('Strings', style: TextStyle(color: Colors.white),),
              ),
              DropdownMenuItem(
                value: 'Yamaha',
                child: Text('Yamaha', style: TextStyle(color: Colors.white),),
              ),
              DropdownMenuItem(
                value: 'Flute',
                child: Text('Flute', style: TextStyle(color: Colors.white),),
              ),
            ],
            onChanged: (value) {
              setState(() => choice = value,);
              load('assets/sf2/$choice.sf2');
            },
          ),
        ],
      ),
      body: InteractivePiano(
        highlightedNotes: [NotePosition(note: Note.C, octave: 3)],
        naturalColor: Colors.white,
        accidentalColor: Colors.black,
        keyWidth: 59,
        noteRange: NoteRange.forClefs([
          Clef.Treble,
        ],),
        onNotePositionTapped: (position) {
          // Use an audio library like flutter_midi to play the sound
          flutterMidi.playMidiNote(midi: position.pitch);
          // flutterMidi.stopMidiNote(midi: 38);
        },
      ),
    );
  }
}
