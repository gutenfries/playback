# playback

## <u>_Looking for a good repository/software name_</u>

> Warning: `playback` is still in development and breaking changes are to be expected.

> ## Note:

> Python **_Will Not Be Accepted_** in this codebase.

playback is an open-sourced project that takes images of sheet music and converts them to MIDI files (to then either be played back, put into a DAW, or put into music notation software).

There is not much documentation currently, as the project is still in the early development stages.

Below is a graphical representation of the dataflow for the core (raw image to MIDI) pipeline:

Some limitations of this model should be noted:

-   time signature changes are not supported
-   tempo changes are not supported
-   key signature changes may be difficult to implement
-   swing is not supported

A possible workaround for some of these difficulties is to use more image processing to separate the input into several inputs, then process them separately as if they were independent inputs. (utilizing specialized subprocesses)

```mermaid
graph TD;

a1(("Input (Raw Image)"));
a1 --> b1[Segmented Image];

subgraph TempBuffer
    e1{{"Note value buffer (tonal value)"}};
    e2{{"Note value buffer (time value)"}};
    e1 & e2 --> e3{{"Note value buffer (cmplx value, including vtime)"}};
    e3 --> e4{{"Note value buffer (cmplx value, including vtime and velocity)"}};

end

subgraph SMFBuffer

    e4 --> f1{{"SMFEvent buffer"}};
    f2{{"SMFMetaEvent buffer"}};
    f1 --> f3{{"Complete SMF MIDI buffer"}};
    f2 --> f3;

end

subgraph Segmentation
    %% for finding the unique notes
    b1 --> c1[Clef];
    b1 --> c2[Barlines];
        c1 & c2 --> d1;
    %% said unique notes
    b1 --> c3[Musical Entities];
    %% Meta information (also musically important)
    b1 --> c6["Key Signature (or 'accidentals' or 'sharps/flats')"];
    b1 --> c4[Tempo];
    b1 --> c5[Time Signature];
        c4 & c5 & c6 --> f2;

    subgraph Musical Entities

        %% affects vtime && pitch
        c3 --> d1["Notes & Rests (including accidentals)"];
            d1 --> e1 & e2;
        %% affects vtime
        c3 --> d2[Slurs & Ties];
            d2 --> e2;
        %% affects velocity
        c3 --> d3[Articulations];
        c3 --> d4[Dynamic Marks];
            d3 & d4 --> e4;

    end

end

f3 --> g1[("Final SMF buffer")];

```
