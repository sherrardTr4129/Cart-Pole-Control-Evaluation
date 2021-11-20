# Cart Pole Control Methodology Evaluation
This repository contains two seperate implementations of a cart-pole control solution. The first is implemented in MATLAB using traditional state-space control techniques. The second method makes use of a Deep Q-Learning Network (DQN) to learn the proper action policy using reinforcement learning techniques.

## DQN Based Solution (Python3)

### Python Dependencies
All required python3 dependencies are enumerated in the requirements.txt file. You can run the following command in a terminal window to install all dependencies:

```bash
pip3 install -r DQN_method/requirements.txt
```

### Running Training
To train the model, run the following command in a terminal.

```bash
python3 cartpole.py --train --dest <model_save_path> --episodes <num_episodes>
```

**NOTE:** Make sure to run the script from within the DQN\_method directory. The script writes data to a local directory in said directory structure using relative pathnames.
### Running Inference
To run inference using the trained model, run the following command in the terminal:

```bash
python3 cartpole.py --infer --model <model_path> --iter <iter_number> --output data/<file_name.csv>
```

In either case, once inference is complete and the simulation terminates, the state data obtained over the course of the simulation will be saved to a csv file in the DQN\_method directory

## State-Space Control Solution (MATLAB)

## Credits:

The cart-pole DQN setup was extended from code found [here](https://github.com/gsurma/cartpole).

The State-Space base simulink simulation model was extended from:
