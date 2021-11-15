import random
import csv
from datetime import datetime
import gym
import numpy as np
import argparse
from collections import deque
from keras.models import Sequential, load_model
from keras.layers import Dense
from tensorflow.keras.optimizers import Adam

# define enviornment name
ENV_NAME = "CartPole-v1"

# define various hyper-parameters
GAMMA = 0.95
LEARNING_RATE = 0.001

MEMORY_SIZE = 1000000
BATCH_SIZE = 20

EXPLORATION_MAX = 1.0
EXPLORATION_MIN = 0.01
EXPLORATION_DECAY = 0.995

# define number of training episodes
MAX_EPISODES = 500

class DQNSolver:
    def __init__(self, observation_space, action_space, model_filename=None):
        """
        initialize DQN manager object
        """
        self.exploration_rate = EXPLORATION_MAX

        self.action_space = action_space
        self.memory = deque(maxlen=MEMORY_SIZE)

        # if no model file_name was provided, make new model
        if(model_filename is None):
            self.model = Sequential()
            self.model.add(Dense(24, input_shape=(observation_space,), activation="relu"))
            self.model.add(Dense(24, activation="relu"))
            self.model.add(Dense(self.action_space, activation="linear"))
            self.model.compile(loss="mse", optimizer=Adam(lr=LEARNING_RATE))

        # otherwise load model from file
        else:
            self.model = load_model(model_filename)

    def remember(self, state, action, reward, next_state, done):
        """
        append current enviornment state to memory
        """
        self.memory.append((state, action, reward, next_state, done))

    def act(self, state):
        """
        take action based on current observed state.

        state -> observed state of the environment
        """
        if np.random.rand() < self.exploration_rate:
            return random.randrange(self.action_space)
        q_values = self.model.predict(state)
        return np.argmax(q_values[0])

    def experience_replay(self):
        if len(self.memory) < BATCH_SIZE:
            return
        batch = random.sample(self.memory, BATCH_SIZE)
        for state, action, reward, state_next, terminal in batch:
            q_update = reward
            if not terminal:
                q_update = (reward + GAMMA * np.amax(self.model.predict(state_next)[0]))
            q_values = self.model.predict(state)
            q_values[0][action] = q_update
            self.model.fit(state, q_values, verbose=0)
        self.exploration_rate *= EXPLORATION_DECAY
        self.exploration_rate = max(EXPLORATION_MIN, self.exploration_rate)


def cartpole_training(render_training_image = False):
    """
    this function performs episodic training of the 
    cart-pole DQN model using the Open AI Gym enviornment.
    A copy of the model will be saved to "model/cartpole_model".

    params:
        render_training_image (bool): should the episode be visualized?
    returns:
        None
    """
    # set up enviornment for cart-pole
    env = gym.make(ENV_NAME)

    # set up observation and action space instnaces
    observation_space = env.observation_space.shape[0]
    action_space = env.action_space.n

    # set up DQN objects
    dqn_solver = DQNSolver(observation_space, action_space)
    run = 0

    # start episodic training
    while True:
        # save model once we've reached MAX_EPISODES
        if(run >= MAX_EPISODES):
            dqn_solver.model.save("model/cartpole_model")
            break

        # reset enviornment before episode start
        run += 1
        state = env.reset()
        state = np.reshape(state, [1, observation_space])
        step = 0

        # begin episode
        while True:
            step += 1

            # render training if flag was set
            if(render_training_image):
                env.render()

            # get action from current state using DQN model
            action = dqn_solver.act(state)

            # advance enviornment state by taking action
            state_next, reward, terminal, info = env.step(action)

            # modify reward as positive or negative depending on outcome of movement
            # (i.e. did we lose balance?)
            reward = reward if not terminal else -reward

            # get next state
            state_next = np.reshape(state_next, [1, observation_space])

            # append current state, action and reward to memory
            dqn_solver.remember(state, action, reward, state_next, terminal)

            # increment state
            state = state_next

            # if we have lose control, end the episode
            # and log data
            if terminal:
                print("Run: " + str(run) + ", exploration: " + str(dqn_solver.exploration_rate) + ", score: " + str(step))
                break

            # perform replay process
            dqn_solver.experience_replay()

def write_state_data(state_dict, filename, time_step):
    """
    this function writes out data within
    state_dict to a csv file with name 'filename'
    """
    with open(filename, "w", newline='') as csvfile:
        csv_writer = csv.writer(csvfile, delimiter=",", quotechar="|", quoting=csv.QUOTE_MINIMAL)
        csv_writer.writerow(["time (s)", "cart_pos (m)", "cart_vel (m/s)", "pole_ang (rad)", "pole_ang_vel (rad/s)"])

        # extract data
        cart_pos_list = state_dict["cart_pos"]
        cart_vel_list = state_dict["cart_vel"]
        pole_ang_list = state_dict["pole_ang"]
        pole_ang_vel_list = state_dict["pole_ang_vel"]

        # all lists should be same lenght, so just choose one for
        # indexing
        list_len = len(cart_pos_list)
        cur_time = 0

        # write out individual data points
        for i in range(list_len):
            csv_writer.writerow([cur_time, cart_pos_list[i], 
                cart_vel_list[i], pole_ang_list[i], pole_ang_vel_list[i]])

            # increment time 
            cur_time += time_step


def cartpole_inference(model_file_name, render_training_image=True):
    """
    this function allows a trained DQN model to be run
    within the simulation enviornment. A disturbance will be
    introduced during the episode and the performance 
    of the system will be analysed.
    """
    # set up enviornment for cart-pole
    env = gym.make(ENV_NAME)

    # set up observation and action space instnaces
    observation_space = env.observation_space.shape[0]
    action_space = env.action_space.n

    # set up DQN objects
    dqn_solver = DQNSolver(observation_space, action_space, model_file_name)
    step = 0
    state = env.reset()
    state = np.reshape(state, [1, observation_space])

    # make new state dictionary
    state_dict = {"cart_pos": list(), "cart_vel": list(), "pole_ang": list(), "pole_ang_vel": list()}

    # begin episode
    while True:
        step += 1

        # render training if flag was set
        if(render_training_image):
            env.render()

        # get action from current state using DQN model
        action = dqn_solver.act(state)

        # update state_dict
        state_unpack = state[0]
        state_dict["cart_pos"].append(state_unpack[0])
        state_dict["cart_vel"].append(state_unpack[0])
        state_dict["pole_ang"].append(state_unpack[0])
        state_dict["pole_ang_vel"].append(state_unpack[3])

        # advance enviornment state by taking action
        state_next, reward, terminal, info = env.step(action)

        # modify reward as positive or negative depending on outcome of movement
        # (i.e. did we lose balance?)
        reward = reward if not terminal else -reward

        # get next state
        state_next = np.reshape(state_next, [1, observation_space])

        # append current state, action and reward to memory
        dqn_solver.remember(state, action, reward, state_next, terminal)

        # increment state
        state = state_next

        # if we have lose control, end the episode
        # and log data
        if terminal:
            now = datetime.now()
            dt_string = now.strftime("%d_%m_%Y-%H-%M-%S")
            filename = "run_%s.csv" % dt_string

            print("run ended")

            # write data to disk
            write_state_data(state_dict, filename, env.tau)

            print("wrote data to %s" % filename)

            break

        # perform replay process
        dqn_solver.experience_replay()

if __name__ == "__main__":
    # set up arg parser
    parser = argparse.ArgumentParser(description='Cartpole DQN Model Traning and Evaluation')
    parser.add_argument("-t", "--train", dest="toTrainOrNot", action="store_true", help="set this flag to train the model")
    parser.add_argument("-i", "--infer", dest="toTrainOrNot", action="store_false", help="set this flag to run inference.")
    parser.add_argument("-m", "--model", type=str, action="store", help="filename for model to be loaded (default: model/cartpole_model)")

    # parse arguments
    parser.set_defaults(toTrainOrNot=True)
    args = parser.parse_args()

    # train model, or run inference based on user input
    if(args.toTrainOrNot):
        print("training model...")
        cartpole_training()

    elif(not args.toTrainOrNot):
        print("running inference...")
        cartpole_inference(args.model)

