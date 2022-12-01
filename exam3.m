clc, clear all, close all

%% Inicio Graficar Nodos
% Posiciones de los nodos---------------------------------------------------
nodesCoordinates=zeros(30,2);
nodesCoordinates(1,1)=34; nodesCoordinates(1,2)=14; nodesCoordinates(2,1)=34; nodesCoordinates(2,2)=10;
nodesCoordinates(3,1)=24; nodesCoordinates(3,2)=38; nodesCoordinates(4,1)=2; nodesCoordinates(4,2)=3;
nodesCoordinates(5,1)=1; nodesCoordinates(5,2)=28; nodesCoordinates(6,1)=24; nodesCoordinates(6,2)=5;
nodesCoordinates(7,1)=32; nodesCoordinates(7,2)=25; nodesCoordinates(8,1)=3; nodesCoordinates(8,2)=3;
nodesCoordinates(9,1)=6; nodesCoordinates(9,2)=32; nodesCoordinates(10,1)=4; nodesCoordinates(10,2)=10;
nodesCoordinates(11,1)= 10;nodesCoordinates(11,2)=5; nodesCoordinates(12,1)=35; nodesCoordinates(12,2)=28;
nodesCoordinates(13,1)=30; nodesCoordinates(13,2)=27; nodesCoordinates(14,1)=21; nodesCoordinates(14,2)=14;
nodesCoordinates(15,1)=27; nodesCoordinates(15,2)=5; nodesCoordinates(16,1)=6; nodesCoordinates(16,2)=1;
nodesCoordinates(17,1)=39; nodesCoordinates(17,2)=39; nodesCoordinates(18,1)=5; nodesCoordinates(18,2)=19;
nodesCoordinates(19,1)=27; nodesCoordinates(19,2)=12; nodesCoordinates(20,1)=31; nodesCoordinates(20,2)=23;
nodesCoordinates(21,1)=18; nodesCoordinates(21,2)=11; nodesCoordinates(22,1)=31; nodesCoordinates(22,2)=36;
nodesCoordinates(23,1)=30; nodesCoordinates(23,2)=17; nodesCoordinates(24,1)=38; nodesCoordinates(24,2)=11;
nodesCoordinates(25,1)=22; nodesCoordinates(25,2)=39; nodesCoordinates(26,1)=11; nodesCoordinates(26,2)=11;
nodesCoordinates(27,1)=38; nodesCoordinates(27,2)=3; nodesCoordinates(28,1)=12; nodesCoordinates(28,2)=24;
nodesCoordinates(29,1)=9; nodesCoordinates(29,2)=26; nodesCoordinates(30,1)=32; nodesCoordinates(30,2)=21;

RC = 10; % Radio de cobertura
for i=1:length(nodesCoordinates)
    for j=1:length(nodesCoordinates)

            dij=sqrt( ( nodesCoordinates(i,1)-nodesCoordinates(j,1) )^2+( nodesCoordinates(i,2)-nodesCoordinates(j,2) )^2);
            if(dij<=RC) & i~=j

                matrLinks(i,j)=dij;

                line([nodesCoordinates(i,1), nodesCoordinates(j,1)], [nodesCoordinates(i,2), nodesCoordinates(j,2)],'LineStyle',':', 'Color','k', 'LineWidth',1);
                hold on;
            else
                matrLinks(i,j)=inf;
            end

    end
end

for i=1:length(nodesCoordinates)
        x=nodesCoordinates(i,1);
        y=nodesCoordinates(i,2);
        plot(nodesCoordinates(i,1), nodesCoordinates(i,2), 'o', 'LineWidth',1,'MarkerEdgeColor','k', 'MarkerFaceColor','k', 'MarkerSize',7);
        text(x+1, y+0.5, num2str(i), 'FontSize',8, 'FontWeight', 'bold', 'Color','k');
        title('Red Celular')
        % axis([0 110 0 60])
end


%% Fin Graficar Nodos

%% SIMULADOR DE EVENTOS DISCRETOS
% Inicializacion de variables

% Inicialización del tiempo de simulación
t=0;

% Programacion del evento inicial o los eventos iniciales.
evt.t = 0;
evt.type = 'A';
evt.currentNode = 9;
destNode = 17;
nodesStatus = zeros(30, 1);
nodesStatus(evt.currentNode) = 1;

% Adiciono el evento inicial o los eventos iniciales a la cola de eventos.

evtQueue = [evt];

% Desarrollo de la simulación
while length(evtQueue)>0
    evtAct=evtQueue(1);
    evtQueue(1)=[];

    t=evtAct.t;

    % Procesamiento del evento A
    if evtAct.type=='A'
        x=nodesCoordinates(evtAct.currentNode,1);
        y=nodesCoordinates(evtAct.currentNode,2);
        plot(x, y, 'o', 'LineWidth',1,'MarkerEdgeColor','b', 'MarkerFaceColor','b', 'MarkerSize',7)
        if evtAct.currentNode == destNode
            break;
        end

        for i=1:length(matrLinks)

            if ~isinf(matrLinks(evtAct.currentNode, i)) && nodesStatus(i) == 0
                  newEvt.t = matrLinks(evtAct.currentNode, i) * 3.333;
                  newEvt.type = 'A';
                  newEvt.currentNode = i;
                  nodesStatus(i) = 1;
                  evtQueue = [evtQueue newEvt];
            end
        end

    end

    % Procesamiento del evento B
    if evtAct.type=='B'


    end

    % Procesamiento del evento Z
    if evtAct.type=='Z'


    end

    % Organizacion de la cola de eventos
    flag=1;
    while flag==1
        flag=0;
        for i=1:(length(evtQueue)-1)
            if evtQueue(i).t>evtQueue(i+1).t
                temp=evtQueue(i);
                evtQueue(i)=evtQueue(i+1);
                evtQueue(i+1)=temp;
                flag=1;
            end
        end
    end
    % Mostrado de la cola de eventos:
    fprintf('\nCola de eventos:\n');
    for i=1:length(evtQueue)
        fprintf('Evento %s en t=%f\n',evtQueue(i).type,evtQueue(i).t);
    end
    fprintf('----------------\n');
    % pause;
end

fprintf('Tiempo transcurrido: %f  \n',t);


% [p, D, iter] = BFMSpathOT(matrLinks, 9);

%i = 17;
%for j=1:length(p)
%     x=nodesCoordinates(i,1);
%     y=nodesCoordinates(i,2);
%     plot(x, y, 'o', 'LineWidth',1,'MarkerEdgeColor','r', 'MarkerFaceColor','r', 'MarkerSize',7)
%     if (i == 9)
%         break;
%     end
%     i = p(i);
%end

% ====================================================================
function [p,D,iter] = BFMSpathOT(G,r)
% --------------------------------------------------------------------
% Basic form of the Bellman-Ford-Moore Shortest Path algorithm
% Assumes G(N,A) is in sparse adjacency matrix form, with |N| = n,
% |A| = m = nnz(G). It constructs a shortest path tree with root r which
% is represented by an vector of parent 'pointers' p, along with a vector
% of shortest path lengths D.
% Complexity: O(mn)
% Derek O'Connor, 19 Jan, 11 Sep 2012.  derekroconnor@eircom.net
% --------------------------------------------------------------------
% Unlike the original BFM algorithm, this does an optimality test on the
% SP Tree p which may greatly reduce the number of iters to convergence.
% USE:
% n=10^6; G=sprand(n,n,5/n); r=1; format long g;
% tic; [p,D,iter] = BFMSpathOT(G,r);toc, disp([(1:10)' p(1:10) D(1:10)]);
% WARNING:
% This algorithm performs well on random graphs but may perform
% badly on real problems.
% --------------------------------------------------------------------
[m,n,p,D,tail,head,W] = Initialize(G);
p(r)=0; D(r)=0;                  % Set the root of the SP tree (p,D)
for iter = 1:n-1                   % Converges in <= n-1 iters if no
    optimal = true;                % negative cycles exist in G
    for arc = 1:m                  % O(m) optimality test.
        u = tail(arc);
        v = head(arc);
        duv = W(arc);
        if D(v) > D(u) + duv;      %
           D(v) = D(u) + duv;      % Sp Tree not optimal: Update (p,D)
           p(v) = u;               %
           optimal = false;
        end
    end % for arc
    if optimal
        return                     % SP Tree p is optimal;
    end
end % for iter
end
%---------------END BFMSpathOT--------------------------------------

function [m,n,p,D,tail,head,W] = Initialize(G)
%
% Transforms the sparse matrix G into the list-of-arcs form
% and intializes the shortest path parent-pointer and distance
% arrays, p and D.
% Derek O'Connor, 21 Jan 2012

[tail,head,W] = find(G); % Get arc list {u,v,duv, 1:m} from G.
[~,n] = size(G);
m = nnz(G);
p(1:n,1) = 0;            % Shortest path tree of parent pointers
D(1:n,1) = Inf;          % Sh. path distances from node i=1:n to
                         % the root of the sp tree

% NOTE: After a shortest path function calls this function
%       it will need to set D(r) = 0, for a given r, the root
%       of the shortest path tree it is about to construct.
end