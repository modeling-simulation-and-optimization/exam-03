%{
    Exam 3

    Made by:
    Juan Andrés Romero C - 202013449
    Juan Sebastián Alegría - 202011282
%}

clc, clear all, close all

%% Start - Plot nodes
% Node position---------------------------------------------------
nodesCoordinates = zeros(30, 2);
nodesCoordinates(1, 1) = 34; nodesCoordinates(1, 2) = 14; nodesCoordinates(2, 1) = 34; nodesCoordinates(2, 2) = 10;
nodesCoordinates(3, 1) = 24; nodesCoordinates(3, 2) = 38; nodesCoordinates(4, 1) = 2; nodesCoordinates(4, 2) = 3;
nodesCoordinates(5, 1) = 1; nodesCoordinates(5, 2) = 28; nodesCoordinates(6, 1) = 24; nodesCoordinates(6, 2) = 5;
nodesCoordinates(7, 1) = 32; nodesCoordinates(7, 2) = 25; nodesCoordinates(8, 1) = 3; nodesCoordinates(8, 2) = 3;
nodesCoordinates(9, 1) = 6; nodesCoordinates(9, 2) = 32; nodesCoordinates(10, 1) = 4; nodesCoordinates(10, 2) = 10;
nodesCoordinates(11, 1) = 10; nodesCoordinates(11, 2) = 5; nodesCoordinates(12, 1) = 35; nodesCoordinates(12, 2) = 28;
nodesCoordinates(13, 1) = 30; nodesCoordinates(13, 2) = 27; nodesCoordinates(14, 1) = 21; nodesCoordinates(14, 2) = 14;
nodesCoordinates(15, 1) = 27; nodesCoordinates(15, 2) = 5; nodesCoordinates(16, 1) = 6; nodesCoordinates(16, 2) = 1;
nodesCoordinates(17, 1) = 39; nodesCoordinates(17, 2) = 39; nodesCoordinates(18, 1) = 5; nodesCoordinates(18, 2) = 19;
nodesCoordinates(19, 1) = 27; nodesCoordinates(19, 2) = 12; nodesCoordinates(20, 1) = 31; nodesCoordinates(20, 2) = 23;
nodesCoordinates(21, 1) = 18; nodesCoordinates(21, 2) = 11; nodesCoordinates(22, 1) = 31; nodesCoordinates(22, 2) = 36;
nodesCoordinates(23, 1) = 30; nodesCoordinates(23, 2) = 17; nodesCoordinates(24, 1) = 38; nodesCoordinates(24, 2) = 11;
nodesCoordinates(25, 1) = 22; nodesCoordinates(25, 2) = 39; nodesCoordinates(26, 1) = 11; nodesCoordinates(26, 2) = 11;
nodesCoordinates(27, 1) = 38; nodesCoordinates(27, 2) = 3; nodesCoordinates(28, 1) = 12; nodesCoordinates(28, 2) = 24;
nodesCoordinates(29, 1) = 9; nodesCoordinates(29, 2) = 26; nodesCoordinates(30, 1) = 32; nodesCoordinates(30, 2) = 21;

RC = 10; % Coverage radius

for i = 1:length(nodesCoordinates)

    for j = 1:length(nodesCoordinates)
        dij = sqrt((nodesCoordinates(i, 1) - nodesCoordinates(j, 1)) ^ 2 + (nodesCoordinates(i, 2) - nodesCoordinates(j, 2)) ^ 2);

        if (dij <= RC) & i ~= j
            matrLinks(i, j) = dij;

            line([nodesCoordinates(i, 1), nodesCoordinates(j, 1)], [nodesCoordinates(i, 2), nodesCoordinates(j, 2)], 'LineStyle', ':', 'Color', 'k', 'LineWidth', 1);
            hold on;
        else
            matrLinks(i, j) = inf;
        end

    end

end

for i = 1:length(nodesCoordinates)
    x = nodesCoordinates(i, 1);
    y = nodesCoordinates(i, 2);
    plot(nodesCoordinates(i, 1), nodesCoordinates(i, 2), 'o', 'LineWidth', 1, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'MarkerSize', 7);
    text(x + 1, y + 0.5, num2str(i), 'FontSize', 8, 'FontWeight', 'bold', 'Color', 'k');
    title('Red Celular')
end

%% End - Plot nodes

%% Discrete Event Simulator
% Variable initialization

% Simulation time initialization
t = 0;

% Programming of the initial event or initial events
initNode = 9;
destNode = 17;
evt.t = 0;
evt.type = 'A';
evt.currentNode = initNode;
evt.prevNode = 0;
sp_trace = Inf(30, 2);

nodesStatus = zeros(30, 1);
nodesStatus(evt.currentNode) = 1;

% Add of the initial event or initial events to the event queue
evtQueue = [evt];

% Simulation development
while length(evtQueue) > 0
    evtAct = evtQueue(1);
    evtQueue(1) = [];

    t = evtAct.t;

    % Event A processing
    if evtAct.type == 'A'
        x = nodesCoordinates(evtAct.currentNode, 1);
        y = nodesCoordinates(evtAct.currentNode, 2);
        plot(x, y, 'o', 'LineWidth', 1, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b', 'MarkerSize', 7)
        sp_trace(evtAct.currentNode, 1) = evtAct.prevNode;
        sp_trace(evtAct.currentNode, 2) = evtAct.t;

        if evtAct.currentNode == destNode
            break;
        end

        for i = 1:length(matrLinks)

            if ~isinf(matrLinks(evtAct.currentNode, i)) && nodesStatus(i) == 0
                newEvt.t = matrLinks(evtAct.currentNode, i) * 3.333;
                newEvt.type = 'A';
                newEvt.currentNode = i;
                newEvt.prevNode = evtAct.currentNode;
                nodesStatus(i) = 1;
                evtQueue = [evtQueue newEvt];
            end

        end

    end

    % Event queue organization
    flag = 1;

    while flag == 1
        flag = 0;

        for i = 1:(length(evtQueue) - 1)

            if evtQueue(i).t > evtQueue(i + 1).t
                temp = evtQueue(i);
                evtQueue(i) = evtQueue(i + 1);
                evtQueue(i + 1) = temp;
                flag = 1;
            end

        end

    end

    % Event queue display
    fprintf('\nCola de eventos:\n');

    for i = 1:length(evtQueue)
        fprintf('Evento %s en t=%f. Nodo Encolado: %d\n', evtQueue(i).type, evtQueue(i).t, evtQueue(i).currentNode);
    end

    fprintf('----------------\n');
    % pause;
end

i = destNode;
totalTime = 0;

for j = 1:length(sp_trace)
    x = nodesCoordinates(i, 1);
    y = nodesCoordinates(i, 2);
    plot(x, y, 'o', 'LineWidth', 1, 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', 'MarkerSize', 7)

    if (i == initNode)
        break;
    end

    totalTime = totalTime + sp_trace(i, 2);
    i = sp_trace(i, 1);
end

fprintf('Tiempo total de recorrido: %f nanosegundos\n', totalTime)
