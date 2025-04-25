// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Todo {
    struct TodoList {
        string name;
        bool isDone;
    }

    // Mapping from user address to task IDs
    mapping(address => uint256[]) private userTasks;
    TodoList[] private tasks;

    event TaskAdded(uint256 taskId, string taskName, address indexed user);
    event TaskUpdated(uint256 indexed taskId, string taskName);
    event TaskDeleted(uint256 indexed taskId);
    event TaskMarkedDone(uint256 indexed taskId, bool isDone);

    function addTask(string calldata taskName) public {
        tasks.push(TodoList(taskName, false));
        uint256 taskId = tasks.length - 1;
        userTasks[msg.sender].push(taskId);

        emit TaskAdded(taskId, taskName, msg.sender);
    }

    function updateTask(uint _index, string memory _name) public {
        require(_index < userTasks[msg.sender].length, "Invalid task index");
        uint256 taskId = userTasks[msg.sender][_index];

        require(taskId < tasks.length, "Task does not exist"); // Added bounds check

        tasks[taskId].name = _name;
        emit TaskUpdated(taskId, _name);
    }

    function deleteTask(uint _index) public {
        require(userTasks[msg.sender].length > 0, "No tasks to delete");
        require(_index < userTasks[msg.sender].length, "Invalid task index");

        uint256 taskId = userTasks[msg.sender][_index];

        require(taskId < tasks.length, "Task does not exist"); // Added bounds check

        // Swap and pop to remove efficiently
        uint256 lastIndex = userTasks[msg.sender].length - 1;
        userTasks[msg.sender][_index] = userTasks[msg.sender][lastIndex];
        userTasks[msg.sender].pop();

        emit TaskDeleted(taskId);
    }

    function markDoneTask(uint _index) public {
        require(_index < userTasks[msg.sender].length, "Invalid task index");
        uint256 taskId = userTasks[msg.sender][_index];

        require(taskId < tasks.length, "Task does not exist"); // Added bounds check

        tasks[taskId].isDone = !tasks[taskId].isDone;
        emit TaskMarkedDone(taskId, tasks[taskId].isDone);
    }

    function getAllTasks() public view returns (TodoList[] memory) {
        uint256[] memory taskIds = userTasks[msg.sender];
        TodoList[] memory userTaskList = new TodoList[](taskIds.length);

        for (uint i = 0; i < taskIds.length; i++) {
            require(taskIds[i] < tasks.length, "Task does not exist"); // Added bounds check
            userTaskList[i] = tasks[taskIds[i]];
        }

        return userTaskList;
    }
}
